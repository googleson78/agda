{-# LANGUAGE TemplateHaskell #-}

module InternalTests.Termination.Semiring
  ( semiringInvariant
  , tests
  ) where

import Agda.Termination.Semiring

import InternalTests.Helpers

------------------------------------------------------------------------------
-- Properties

-- | Semiring invariant.

-- I think it's OK to use the same x, y, z triple for all the
-- properties below.

semiringInvariant :: Eq a
                  => Semiring a
                  -> a -> a -> a -> Bool
semiringInvariant (Semiring { add = (+), mul = (*)
                            , zero = zero --, one = one
                            }) = \x y z ->
  isAssociative (+)           x y z &&
  isIdentity zero (+)         x     &&
  isCommutative (+)           x y   &&
  isAssociative (*)           x y z &&
--  isIdentity one (*)          x     &&
  isLeftDistributive (*) (+)  x y z &&
  isRightDistributive (*) (+) x y z &&
  isZero zero (*)             x


prop_integerSemiring :: Integer -> Integer -> Integer -> Bool
prop_integerSemiring = semiringInvariant integerSemiring

prop_intSemiring :: Int -> Int -> Int -> Bool
prop_intSemiring = semiringInvariant intSemiring

prop_boolSemiring :: Bool -> Bool -> Bool -> Bool
prop_boolSemiring = semiringInvariant boolSemiring

------------------------------------------------------------------------
-- * All tests
------------------------------------------------------------------------

-- Template Haskell hack to make the following $quickCheckAll work
-- under ghc-7.8.
return [] -- KEEP!

-- | All tests as collected by 'quickCheckAll'.

tests :: IO Bool
tests = do
  putStrLn "InternalTests.Termination.Semiring"
  $quickCheckAll
