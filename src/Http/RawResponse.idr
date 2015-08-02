module Http.RawResponse

import Classes.Verified

data RawResponse a = MkRawResponse a

instance Eq a => Eq (RawResponse a) where
  (MkRawResponse a) == (MkRawResponse b) = a == b
  (MkRawResponse a) /= (MkRawResponse b) = a /= b

instance Show a => Show (RawResponse a) where
  show (MkRawResponse a) = show a

instance Functor RawResponse where
  map f (MkRawResponse a) = MkRawResponse (f a)

instance Applicative RawResponse where
  pure = MkRawResponse
  (MkRawResponse f) <*> (MkRawResponse a) = MkRawResponse (f a)

instance Monad RawResponse where
  (MkRawResponse a) >>= f = f a

instance Foldable RawResponse where
  foldr f z (MkRawResponse a) = f a z

instance Traversable RawResponse where
  traverse f (MkRawResponse x) = [| MkRawResponse (f x) |]

instance Semigroup a => Semigroup (RawResponse a) where
  (MkRawResponse a) <+> (MkRawResponse b) = MkRawResponse (a <+> b)

instance Monoid a => Monoid (RawResponse a) where
  neutral = MkRawResponse neutral

instance Cast a (RawResponse a) where
  cast = pure
instance Cast (RawResponse a) a where
  cast (MkRawResponse a) = a

instance VerifiedFunctor RawResponse where
  functorIdentity (MkRawResponse x) = Refl
  functorComposition (MkRawResponse x) f g = Refl

instance VerifiedApplicative RawResponse where
  applicativeMap (MkRawResponse x) g = Refl
  applicativeIdentity (MkRawResponse x) = Refl
  applicativeComposition (MkRawResponse x)
                      (MkRawResponse f) (MkRawResponse g) = Refl
  applicativeHomomorphism x f = Refl
  applicativeInterchange x (MkRawResponse f) = Refl

instance VerifiedMonad RawResponse where
  monadApplicative (MkRawResponse f) (MkRawResponse x) = Refl
  monadLeftIdentity x f = Refl
  monadRightIdentity (MkRawResponse x) = Refl
  monadAssociativity (MkRawResponse x) f g = Refl

instance VerifiedSemigroup a => VerifiedSemigroup (RawResponse a) where
  semigroupOpIsAssociative (MkRawResponse a) (MkRawResponse b) (MkRawResponse c) = ?semiproof

instance VerifiedMonoid a => VerifiedMonoid (RawResponse a) where
  monoidNeutralIsNeutralL (MkRawResponse a) = ?monoidproof1
  monoidNeutralIsNeutralR (MkRawResponse a) = ?monoidproof2

semiproof = proof
  intros
  rewrite (semigroupOpIsAssociative a b c)
  trivial

monoidproof1 = proof
  intros
  rewrite (monoidNeutralIsNeutralL a)
  trivial

monoidproof2 = proof
  intros
  rewrite (monoidNeutralIsNeutralR a)
  trivial
