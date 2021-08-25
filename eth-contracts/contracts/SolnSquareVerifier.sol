pragma solidity ^0.5.0;

import "./ERC721Mintable.sol";

// TODO define a contract call to the zokrates generated solidity contract <Verifier> or <renamedVerifier>
contract Verifier {
    function verifyTx(
        uint256[2] memory A,
        uint256[2] memory A_p,
        uint256[2][2] memory B,
        uint256[2] memory B_p,
        uint256[2] memory C,
        uint256[2] memory C_p,
        uint256[2] memory H,
        uint256[2] memory K,
        uint256[2] memory input
    ) public returns (bool r);
}

// TODO define another contract named SolnSquareVerifier that inherits from your ERC721Mintable class
// TODO define a solutions struct that can hold an index & an address
// TODO define an array of the above struct
// TODO define a mapping to store unique solutions submitted
// TODO Create an event to emit when a solution is added
// TODO Create a function to add the solutions to the array and emit the event
// TODO Create a function to mint new NFT only after the solution has been verified
//  - make sure the solution is unique (has not been used before)
//  - make sure you handle metadata as well as tokenSuplly
contract SolnSquareVerifier is ERC721MintableComplete {
    Verifier private _verifier;

    struct Solution {
        uint256 index;
        address solAddress;
        bool isMinted;
    }

    Solution[] private _solutionList;

    mapping(bytes32 => Solution) _solutions;

    event SolutionAdded(
        uint256 indexed _solutionIndex,
        address indexed _solutionAddress
    );

    constructor(
        address _verifierAddress,
        string memory name,
        string memory symbol
    ) public ERC721MintableComplete(name, symbol) {
        _verifier = Verifier(_verifierAddress);
    }

    function addSolution(
        uint256[2] memory A,
        uint256[2] memory A_p,
        uint256[2][2] memory B,
        uint256[2] memory B_p,
        uint256[2] memory C,
        uint256[2] memory C_p,
        uint256[2] memory H,
        uint256[2] memory K,
        uint256[2] memory input
    ) public {
        bytes32 key = keccak256(abi.encodePacked(input[0], input[1]));

        require(
            _solutions[key].solAddress == address(0),
            "Solution already exists"
        );

        bool verified = _verifier.verifyTx(A, A_p, B, B_p, C, C_p, H, K, input);

        require(verified, "Solution could not be verified");

        emit SolutionAdded(_solutionList.length, msg.sender);

        _solutions[key] = Solution(_solutionList.length, msg.sender, false);
        _solutionList.push(_solutions[key]);
    }

    function mintNewNft(
        uint256 a,
        uint256 b,
        address to
    ) public {
        bytes32 key = keccak256(abi.encodePacked(a, b));

        require(
            _solutions[key].solAddress != address(0),
            "Solution does not exist"
        );

        require(
            _solutions[key].isMinted == false,
            "Solution token is already minted"
        );

        require(
            _solutions[key].solAddress == msg.sender,
            "Caller is not the solution address"
        );

        super.mint(to, _solutions[key].index);
        _solutions[key].isMinted = true;
    }

    // struct Solution {
    //     uint256 index;
    //     address solAddress;
    // }

    // Solution[] private _solutionsList;

    // mapping(uint256 => Solution) private _solutions;

    // event SolutionAdded(uint256 indexed index, address indexed solAddress);

    // function addSolution(uint256 _solutionIndex, address _solutionAddress)
    //     public
    // {
    //     _solutions[_solutionIndex] = Solution(_solutionIndex, _solutionAddress);
    //     _solutionsList.push(_solutions[_solutionIndex]);
    //     emit SolutionAdded(_solutionIndex, _solutionAddress);
    // }
}
