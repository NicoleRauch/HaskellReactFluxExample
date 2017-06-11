module Main where

import qualified React.Flux  as F
import qualified Data.Map.Strict as M
import ReactFluxExample
-- import ReactFluxExample_ComponentDidUpdate
-- import ReactFluxExample_Lifecycle
import Data.JSString

-- the first argument of reactRender is the id of the DOM element in index.html that the app will be rendered into
main :: IO ()
main = do
  -- LC F.registerInitialStore $ ExampleState False
  -- CDU F.registerInitialStore $ ExampleState
  F.registerInitialStore $ ExampleState M.empty
  F.reactRenderView (pack "example") exampleApp
