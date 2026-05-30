module Main
 
import QuickCheck
import Math.Chromogeometry
import Math.Pixel
 
%default total
 
-- 1. Generators & Arbitrary instances
public export
Arbitrary (Pixel Integer) where
  arbitrary = do
    x <- arbitrary
    y <- arbitrary
    pure (MkPixel x y)
  coarbitrary (MkPixel x y) = coarbitrary (x, y)
 
-- 2. Properties
 
||| Checks that for collinear points on the 1D X axis, the triple quad formula evaluates exactly to zero.
prop_triple_quad_audit_nl : Property
prop_triple_quad_audit_nl = forAll {a = (Integer, Integer)} {prop = Bool} arbitrary (MkFn (\(a, b) =>
  let p1 = MkPixel a 0
      p2 = MkPixel b 0
      p3 = MkPixel (a + b) 0
  in tripleQuadAuditNL Blue p1 p2 p3 == True))
 
||| Verifies N.J. Wildberger's Theorem 6 (Coloured quadrances):
||| Q_b^2 = Q_r^2 + Q_g^2
prop_three_fold_symmetry_nl : Property
prop_three_fold_symmetry_nl = forAll {a = (Pixel Integer, Pixel Integer)} {prop = Bool} arbitrary (MkFn (\(p1, p2) =>
  let qb = quadranceNL Blue p1 p2
      qr = quadranceNL Red p1 p2
      qg = quadranceNL Green p1 p2
  in (qb * qb) == (qr * qr) + (qg * qg)))
 
||| Verifies Theorem 8 (Three-Fold Quadrea Invariant):
||| A_b = -A_r = -A_g
prop_three_fold_quadrea_nl : Property
prop_three_fold_quadrea_nl = forAll {a = (Pixel Integer, Pixel Integer, Pixel Integer)} {prop = Bool} arbitrary (MkFn (\(p1, p2, p3) =>
  let ab = archimedesNL Blue p1 p2 p3
      ar = archimedesNL Red p1 p2 p3
      ag = archimedesNL Green p1 p2 p3
  in ab == -ar && ab == -ag))
 
||| Helper to validate fraction sum for spreads: 1/s_b + 1/s_r + 1/s_g = 2
validateFractionSum : (Integer, Integer) -> (Integer, Integer) -> (Integer, Integer) -> Bool
validateFractionSum (nb, db) (nr, dr) (ng, dg) =
  if db == 0 || dr == 0 || dg == 0 then True
  else
    -- sb = nb/db, sr = nr/dr, sg = ng/dg
    -- 1/sb + 1/sr + 1/sg = db/nb + dr/nr + dg/ng = 2
    -- (db*nr*ng + dr*nb*ng + dg*nb*nr) == 2 * nb * nr * ng
    let lhs = db * nr * ng + dr * nb * ng + dg * nb * nr
        rhs = 2 * nb * nr * ng
    in lhs == rhs
 
||| Verifies Theorem 7 (Coloured spreads):
||| 1/s_b + 1/s_r + 1/s_g = 2
prop_three_fold_spread_nl : Property
prop_three_fold_spread_nl = forAll {a = (Pixel Integer, Pixel Integer, Pixel Integer)} {prop = Bool} arbitrary (MkFn (\(p1, p2, p3) =>
  let isCollinear = archimedesNL Blue p1 p2 p3 == 0
  in if isCollinear
       then True
       else
         let sb = spreadNL Blue p1 p2 p3
             sr = spreadNL Red p1 p2 p3
             sg = spreadNL Green p1 p2 p3
         in validateFractionSum sb sr sg))
 
prop_blue_perp_nl : Property
prop_blue_perp_nl = forAll {a = ()} {prop = Bool} arbitrary (MkFn (\() =>
  let v1 = MkPixel 1 0
      v2 = MkPixel 0 1
  in isPerpendicularNL Blue v1 v2 == True))
 
prop_red_perp_nl : Property
prop_red_perp_nl = forAll {a = ()} {prop = Bool} arbitrary (MkFn (\() =>
  let v1 = MkPixel 1 1
      v2 = MkPixel 1 1
  in isPerpendicularNL Red v1 v2 == True))
 
prop_green_perp_nl : Property
prop_green_perp_nl = forAll {a = ()} {prop = Bool} arbitrary (MkFn (\() =>
  let v1 = MkPixel 1 0
      v2 = MkPixel 1 0
  in isPerpendicularNL Green v1 v2 == True))
 
main : IO ()
main = do
  putStrLn "━━━ Math.Chromogeometry (QuickCheck) ━━━"
  
  let r1 = quickCheck prop_three_fold_symmetry_nl
  putStrLn $ "  Three-Fold Symmetry (Q_b^2 = Q_r^2 + Q_g^2): " ++ r1.msg
  
  let r2 = quickCheck prop_three_fold_spread_nl
  putStrLn $ "  Three-Fold Spread (1/s_b + 1/s_r + 1/s_g = 2): " ++ r2.msg
  
  let r3 = quickCheck prop_triple_quad_audit_nl
  putStrLn $ "  Colinear Triple Quad Audit (NL): " ++ r3.msg
  
  let r4 = quickCheck prop_three_fold_quadrea_nl
  putStrLn $ "  Three-Fold Quadrea Invariant (A_b = -A_r = -A_g): " ++ r4.msg
  
  let r5 = quickCheck prop_blue_perp_nl
  putStrLn $ "  Blue Perpendicularity (NL): " ++ r5.msg
  
  let r6 = quickCheck prop_red_perp_nl
  putStrLn $ "  Red Perpendicularity (NL): " ++ r6.msg
  
  let r7 = quickCheck prop_green_perp_nl
  putStrLn $ "  Green Perpendicularity (NL): " ++ r7.msg
 
  let allPassed = isJust r1.pass && isJust r2.pass && isJust r3.pass && isJust r4.pass &&
                  isJust r5.pass && isJust r6.pass && isJust r7.pass
  if allPassed then putStrLn "SUCCESS" else putStrLn "FAILURE"
