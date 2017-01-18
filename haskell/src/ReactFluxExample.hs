{-# LANGUAGE TypeFamilies      #-}
{-# LANGUAGE DeriveGeneric     #-}
{-# LANGUAGE DeriveAnyClass    #-}
{-# LANGUAGE OverloadedStrings #-}

module ReactFluxExample where

import           Control.DeepSeq
import           Control.Monad (forM_)
import           Data.Monoid ((<>))
import           Data.Typeable (Typeable)
import qualified Data.Map.Strict as M
import           GHC.Generics (Generic)
import           GHCJS.Types (JSVal)
import           React.Flux
import           React.Flux.Lifecycle

import Debug.Trace


exampleApp :: ReactView ()
exampleApp = defineControllerView "example_app" exampleStore $ \(ExampleState posMap) () ->
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
  }

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
  }

snippet :: ReactView SnippetProps
snippet = defineView "snippet" $ \props ->
        case _markPosition props of
            Nothing -> div_ "Nothing"
            Just pos ->
                div_ . elemString $ "Position " <> show pos

snippet_ :: SnippetProps -> ReactElementM eventHandler ()
snippet_ props = viewWithIKey snippet 1 props mempty

foreign import javascript unsafe
  "$1.getBoundingClientRect().top"
  js_getBoundingClientRectTop :: JSVal -> IO Int

data ExampleState = ExampleState
  { positions :: M.Map String Int
  } deriving (Show, Typeable)

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

exampleStore :: ReactStore ExampleState
exampleStore = mkStore $ ExampleState M.empty

dispatch :: ExampleAction -> [SomeStoreAction]
dispatch a = [SomeStoreAction exampleStore a]
