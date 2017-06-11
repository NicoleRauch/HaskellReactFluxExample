{-# LANGUAGE TypeFamilies      #-}
{-# LANGUAGE DeriveGeneric     #-}
{-# LANGUAGE DeriveAnyClass    #-}
{-# LANGUAGE OverloadedStrings #-}

module ReactFluxExample_ComponentDidUpdate where

import           Control.DeepSeq
import           Data.Typeable (Typeable)
import           GHC.Generics (Generic)
import           React.Flux
import           React.Flux.Lifecycle


exampleApp :: ReactView ()
exampleApp = defineControllerView "ExampleApp" exampleStore $ \_ _ ->
    lifecycleC_


lifecycleC :: ReactView ()
lifecycleC = defineLifecycleView "ALifecycleComponent" () lifecycleConfig
   { lRender = \_ _ -> div_ "Hello Lifecycle!"
   , lComponentDidUpdate = Just $ \_ _ _ _ _ -> putStrLn "Did Update!"
   }

lifecycleC_ :: ReactElementM eventHandler ()
lifecycleC_ = view lifecycleC () mempty

data ExampleState = ExampleState
  deriving (Show, Typeable)

data ExampleAction = ExampleAction
  deriving (Show, Typeable, Generic, NFData)

instance StoreData ExampleState where
    type StoreAction ExampleState = ExampleAction
    transform _ state = return state

exampleStore :: ReactStore ExampleState
exampleStore = mkStore ExampleState
