{-# LANGUAGE TypeFamilies      #-}
{-# LANGUAGE DeriveGeneric     #-}
{-# LANGUAGE DeriveAnyClass    #-}
{-# LANGUAGE OverloadedStrings #-}

{-# LANGUAGE DataKinds, TypeApplications #-}

module ReactFluxExample where

import           Control.DeepSeq
import           Control.Monad (forM_)
import           Data.Monoid ((<>))
import           Data.Typeable (Typeable)
import qualified Data.Map.Strict as M
import           GHC.Generics (Generic)
import           GHCJS.Types (JSVal)
import           React.Flux
import           React.Flux.Outdated

import Debug.Trace


exampleApp :: View '[]
exampleApp = mkControllerView @'[StoreArg ExampleState] "example_app" $ \(ExampleState posMap) ->
    main_ ["role" $= "main"] $ do
        aside_ $ do
            trace (show posMap) mempty
            snippet_ (SnippetProps "1" (M.lookup "1" posMap))

        article_ $ do
            p_ $ do
                exMark_ (MarkProps "1") $ do
                    span_ "Donec pede justo, fringilla vel."


data MarkProps = MarkProps
  { _id :: String
  } deriving (Eq)

exMark :: ReactView MarkProps
exMark = defineLifecycleView "ExampleMark" () lifecycleConfig
   { lRender = \_ _ ->
         mark_ childrenPassedToView
   , lComponentDidMount = Just $ \propsandstate ldom _ -> do
         this <- lThis ldom
         top <- js_getBoundingClientRectTop this
         props <- lGetProps propsandstate
         let actions = dispatch $ AddPosition (_id props) top
         forM_ actions executeAction
   }

exMark_ :: MarkProps -> ReactElementM eventHandler () -> ReactElementM eventHandler ()
exMark_ = view exMark

data SnippetProps = SnippetProps
  { _id2 :: String
  , _markPosition :: Maybe Int
  } deriving (Eq)

instance UnoverlapAllEq SnippetProps

snippet :: View '[SnippetProps]
snippet = mkView "snippet" $ \props ->
        case _markPosition props of
            Nothing -> div_ "Nothing"
            Just pos ->
                div_ . elemString $ "Position " <> show pos

snippet_ :: SnippetProps -> ReactElementM eventHandler ()
snippet_ = view_ snippet "1"

foreign import javascript unsafe
  "$1.getBoundingClientRect().top"
  js_getBoundingClientRectTop :: JSVal -> IO Int

data ExampleState = ExampleState
  { positions :: M.Map String Int
  } deriving (Show, Typeable, Eq)

data ExampleAction = AddPosition String Int
  deriving (Show, Typeable, Generic, NFData)

instance StoreData ExampleState where
    type StoreAction ExampleState = ExampleAction
    transform action state = do
        putStrLn $ "Old state: " <> show state
        putStrLn $ "Action: " <> show action

        let newState = case action of
                     (AddPosition id' pos) -> state { positions = M.alter (\_ -> Just pos) id' (positions state) }

        putStrLn $ "New state: " <> show newState
        return newState

dispatch :: ExampleAction -> [SomeStoreAction]
dispatch a = [someStoreAction @ExampleState a]
