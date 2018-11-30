pragma solidity 0.5.0;

import "./EIP712Sig.sol";

contract UsesEIP712 is EIP712Sig {

  struct SomeStruct {
    bool someBool;
    uint256 someUint256;
    address someAddress;
  }

  address public signer;

  bytes32 constant internal EIP712_SIMPLE_STRUCT_SCHEMA_HASH = keccak256(
    abi.encodePacked(
      "SomeStruct(",
      "bool someBool,",
      "uint256 someUint256,",
      "address someAddress",
      ")"
    )
  );

  constructor(address _signer) public {
    require(_signer != address(0x0), "Signer address was set to 0.");
    signer = _signer;
  }

  function getSomeStructHash(SomeStruct memory simpleStruct)
    internal
    view
    returns (bytes32)
  {
    return hashEIP712Message(hashSomeStruct(simpleStruct));
  }

  function hashSomeStruct(SomeStruct memory simpleStruct)
    internal
    pure
    returns (bytes32)
  {
    return keccak256(
      abi.encodePacked(
        EIP712_SIMPLE_STRUCT_SCHEMA_HASH,
        simpleStruct.someBool,
        simpleStruct.someUint256,
        simpleStruct.someAddress
      )
    );
  }

  function isValidSignature(
    address _signer,
    bytes32 hash,
    uint8 v,
    bytes32 r,
    bytes32 s
  )
    public
    pure
    returns (bool)
  {
    address recovered = ecrecover(
      hash,
      v,
      r,
      s
    );
    return (_signer == recovered);
  }
}
