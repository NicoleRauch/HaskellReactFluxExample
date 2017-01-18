module Main where

import qualified React.Flux  as F
import ReactFluxExample

-- the first argument of reactRender is the id of the DOM element in index.html that the app will be rendered into
main :: IO ()
main = F.reactRender "example" exampleApp ()
