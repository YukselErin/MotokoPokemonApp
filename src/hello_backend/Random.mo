import Nat = "mo:base/Nat";

module {
  public func new() : { next : () -> Nat } =
    object {
      let modulus = 0x7fffffff;
      var state : Nat = 1;

      public func next() : Nat
      {
        state := state * 48271 % modulus;
        state;
      };

    };
};
