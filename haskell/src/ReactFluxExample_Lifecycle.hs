{-# LANGUAGE TypeFamilies      #-}
{-# LANGUAGE DeriveGeneric     #-}
{-# LANGUAGE DeriveAnyClass    #-}
{-# LANGUAGE OverloadedStrings #-}

module ReactFluxExample_Lifecycle where

import           Control.DeepSeq
import           Data.Monoid ((<>))
import           Data.Typeable (Typeable)
import           GHC.Generics (Generic)
import           React.Flux
import           React.Flux.Lifecycle

{- NOINLINE exampleApp  -}
{- NOINLINE lifecycleC  -}
{- NOINLINE exampleStore  -}

exampleApp :: ReactView ()
exampleApp = defineControllerView "ExampleApp" exampleStore $ \(ExampleState visible) () ->
  div_ $ do
    button_ [ onClick $ \_ _ -> dispatch ToggleVisible ] "Click here!"
    div_ . elemString $ "Outside: " ++ show visible
    lifecycleC_ visible $ do
        div_ . elemString $ "Inside: " ++ show visible


lifecycleC :: Typeable a => ReactView a
lifecycleC = defineLifecycleView "ALifecycleComponent" () lifecycleConfig
   { lRender = \_ _ -> childrenPassedToView
   }

lifecycleC_ :: Typeable a => a -> ReactElementM eventHandler () -> ReactElementM eventHandler ()
lifecycleC_ = view lifecycleC

data ExampleState = ExampleState
  { isVisible :: Bool
  } deriving (Show, Typeable)

data ExampleAction = ToggleVisible
  deriving (Show, Typeable, Generic, NFData)

instance StoreData ExampleState where
    type StoreAction ExampleState = ExampleAction
    transform action state = do
        putStrLn $ "Old state: " <> show state
        putStrLn $ "Action: " <> show action

        let newState = case action of
                     ToggleVisible -> state { isVisible = not $ isVisible state }

        putStrLn $ "New state: " <> show newState
        return newState

exampleStore :: ReactStore ExampleState
exampleStore = mkStore $ ExampleState False

dispatch :: ExampleAction -> [SomeStoreAction]
dispatch a = [SomeStoreAction exampleStore a]
