{-# LANGUAGE TypeFamilies      #-}
{-# LANGUAGE DeriveGeneric     #-}
{-# LANGUAGE DeriveAnyClass    #-}
{-# LANGUAGE OverloadedStrings #-}

{-# LANGUAGE DataKinds, TypeApplications #-}

module ReactFluxExample_Lifecycle where

import           Control.DeepSeq
import           Data.Monoid ((<>))
import           Data.Typeable (Typeable)
import           GHC.Generics (Generic)
import           React.Flux
import           React.Flux.Outdated

{- NOINLINE exampleApp  -}
{- NOINLINE lifecycleC  -}
{- NOINLINE exampleStore  -}

exampleApp :: View '[]
exampleApp = mkControllerView @'[StoreArg ExampleState] "ExampleApp" $ \(ExampleState visible) ->
  div_ $ do
    button_ [ onClick $ \_ _ -> dispatch ToggleVisible ] "Click here!"
    div_ . elemString $ "Outside: " ++ show visible
    lifecycleC_ $ do
        div_ . elemString $ "Inside: " ++ show visible


lifecycleC :: ReactView ()
lifecycleC = defineLifecycleView "ALifecycleComponent" () lifecycleConfig
   { lRender = \_ _ -> childrenPassedToView
   }

lifecycleC_ :: ReactElementM eventHandler () -> ReactElementM eventHandler ()
lifecycleC_ = view lifecycleC ()

data ExampleState = ExampleState
  { isVisible :: Bool
  } deriving (Show, Typeable, Eq)

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

dispatch :: ExampleAction -> [SomeStoreAction]
dispatch a = [someStoreAction @ExampleState a]
