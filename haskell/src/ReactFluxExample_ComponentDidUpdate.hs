{-# LANGUAGE TypeFamilies      #-}
{-# LANGUAGE DeriveGeneric     #-}
{-# LANGUAGE DeriveAnyClass    #-}
{-# LANGUAGE OverloadedStrings #-}

{-# LANGUAGE DataKinds, TypeApplications #-}

module ReactFluxExample_ComponentDidUpdate where

import           Control.DeepSeq
import           Data.Typeable (Typeable)
import           GHC.Generics (Generic)
import           React.Flux
import           React.Flux.Outdated


exampleApp :: View '[]
exampleApp = mkControllerView @'[StoreArg ExampleState] "ExampleApp" $ \_ ->
    lifecycleC_


lifecycleC :: ReactView ()
lifecycleC = defineLifecycleView "ALifecycleComponent" () lifecycleConfig
   { lRender = \_ _ -> div_ "Hello Lifecycle!"
   , lComponentDidUpdate = Just $ \_ _ _ _ _ -> putStrLn "Did Update!"
   }

lifecycleC_ :: ReactElementM eventHandler ()
lifecycleC_ = view lifecycleC () mempty

data ExampleState = ExampleState
  deriving (Show, Typeable, Eq)

data ExampleAction = ExampleAction
  deriving (Show, Typeable, Generic, NFData)

instance StoreData ExampleState where
    type StoreAction ExampleState = ExampleAction
    transform _ state = return state
