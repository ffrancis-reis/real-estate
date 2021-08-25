// This file is MIT Licensed.
//
// Copyright 2017 Christian Reitwiessner
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

pragma solidity ^0.5.0;

library Pairing {
    struct G1Point {
        uint256 X;
        uint256 Y;
    }
    // Encoding of field elements is: X[0] * z + X[1]
    struct G2Point {
        uint256[2] X;
        uint256[2] Y;
    }

    /// @return the generator of G1
    function P1() internal pure returns (G1Point memory) {
        return G1Point(1, 2);
    }

    /// @return the generator of G2
    function P2() internal pure returns (G2Point memory) {
        return
            G2Point(
                [
                    11559732032986387107991004021392285783925812861821192530917403151452391805634,
                    10857046999023057135944570762232829481370756359578518086990519993285655852781
                ],
                [
                    4082367875863433681332203403145435568316851327593401208105741076214120093531,
                    8495653923123431417604973247489272438418190587263600148770280649306958101930
                ]
            );
    }

    /// @return the negation of p, i.e. p.addition(p.negate()) should be zero.
    function negate(G1Point memory p) internal pure returns (G1Point memory) {
        // The prime q in the base field F_q for G1
        uint256 q = 21888242871839275222246405745257275088696311157297823662689037894645226208583;
        if (p.X == 0 && p.Y == 0) return G1Point(0, 0);
        return G1Point(p.X, q - (p.Y % q));
    }

    /// @return the sum of two points of G1
    function addition(G1Point memory p1, G1Point memory p2)
        internal
        returns (G1Point memory r)
    {
        uint256[4] memory input;
        input[0] = p1.X;
        input[1] = p1.Y;
        input[2] = p2.X;
        input[3] = p2.Y;
        bool success;
        assembly {
            success := call(sub(gas, 2000), 6, 0, input, 0xc0, r, 0x60)
            // Use "invalid" to make gas estimation work
            switch success
            case 0 {
                invalid()
            }
        }
        require(success);
    }

    /// @return the product of a point on G1 and a scalar, i.e.
    /// p == p.scalar_mul(1) and p.addition(p) == p.scalar_mul(2) for all points p.
    function scalar_mul(G1Point memory p, uint256 s)
        internal
        returns (G1Point memory r)
    {
        uint256[3] memory input;
        input[0] = p.X;
        input[1] = p.Y;
        input[2] = s;
        bool success;
        assembly {
            success := call(sub(gas, 2000), 7, 0, input, 0x80, r, 0x60)
            // Use "invalid" to make gas estimation work
            switch success
            case 0 {
                invalid()
            }
        }
        require(success);
    }

    /// @return the result of computing the pairing check
    /// e(p1[0], p2[0]) *  .... * e(p1[n], p2[n]) == 1
    /// For example pairing([P1(), P1().negate()], [P2(), P2()]) should
    /// return true.
    function pairing(G1Point[] memory p1, G2Point[] memory p2)
        internal
        returns (bool)
    {
        require(p1.length == p2.length);
        uint256 elements = p1.length;
        uint256 inputSize = elements * 6;
        uint256[] memory input = new uint256[](inputSize);
        for (uint256 i = 0; i < elements; i++) {
            input[i * 6 + 0] = p1[i].X;
            input[i * 6 + 1] = p1[i].Y;
            input[i * 6 + 2] = p2[i].X[0];
            input[i * 6 + 3] = p2[i].X[1];
            input[i * 6 + 4] = p2[i].Y[0];
            input[i * 6 + 5] = p2[i].Y[1];
        }
        uint256[1] memory out;
        bool success;
        assembly {
            success := call(
                sub(gas, 2000),
                8,
                0,
                add(input, 0x20),
                mul(inputSize, 0x20),
                out,
                0x20
            )
            // Use "invalid" to make gas estimation work
            switch success
            case 0 {
                invalid()
            }
        }
        require(success);
        return out[0] != 0;
    }

    /// Convenience method for a pairing check for two pairs.
    function pairingProd2(
        G1Point memory a1,
        G2Point memory a2,
        G1Point memory b1,
        G2Point memory b2
    ) internal returns (bool) {
        G1Point[] memory p1 = new G1Point[](2);
        G2Point[] memory p2 = new G2Point[](2);
        p1[0] = a1;
        p1[1] = b1;
        p2[0] = a2;
        p2[1] = b2;
        return pairing(p1, p2);
    }

    /// Convenience method for a pairing check for three pairs.
    function pairingProd3(
        G1Point memory a1,
        G2Point memory a2,
        G1Point memory b1,
        G2Point memory b2,
        G1Point memory c1,
        G2Point memory c2
    ) internal returns (bool) {
        G1Point[] memory p1 = new G1Point[](3);
        G2Point[] memory p2 = new G2Point[](3);
        p1[0] = a1;
        p1[1] = b1;
        p1[2] = c1;
        p2[0] = a2;
        p2[1] = b2;
        p2[2] = c2;
        return pairing(p1, p2);
    }

    /// Convenience method for a pairing check for four pairs.
    function pairingProd4(
        G1Point memory a1,
        G2Point memory a2,
        G1Point memory b1,
        G2Point memory b2,
        G1Point memory c1,
        G2Point memory c2,
        G1Point memory d1,
        G2Point memory d2
    ) internal returns (bool) {
        G1Point[] memory p1 = new G1Point[](4);
        G2Point[] memory p2 = new G2Point[](4);
        p1[0] = a1;
        p1[1] = b1;
        p1[2] = c1;
        p1[3] = d1;
        p2[0] = a2;
        p2[1] = b2;
        p2[2] = c2;
        p2[3] = d2;
        return pairing(p1, p2);
    }
}

contract Verifier {
    using Pairing for *;
    struct VerifyingKey {
        Pairing.G2Point A;
        Pairing.G1Point B;
        Pairing.G2Point C;
        Pairing.G2Point gamma;
        Pairing.G1Point gammaBeta1;
        Pairing.G2Point gammaBeta2;
        Pairing.G2Point Z;
        Pairing.G1Point[] IC;
    }
    struct Proof {
        Pairing.G1Point A;
        Pairing.G1Point A_p;
        Pairing.G2Point B;
        Pairing.G1Point B_p;
        Pairing.G1Point C;
        Pairing.G1Point C_p;
        Pairing.G1Point K;
        Pairing.G1Point H;
    }

    function verifyingKey() internal pure returns (VerifyingKey memory vk) {
        vk.A = Pairing.G2Point(
            [
                0x8d3913b39f10c56b24e4927daa5e0f1625a9ee4a6a56a60c2c3b749f2f51b3c,
                0x1290bb677383f7f80cfa913a060241d475c01080005962bddaacc75ecce9effc
            ],
            [
                0xbb2a2a956571698cd22e40de02da22bad3456e14766205a7bd44f9ae109f06d,
                0x18ec6c77b35b5ddd48ce15cc7ef8d430c2e4d102fbb18e4c31f961e78dce082c
            ]
        );
        vk.B = Pairing.G1Point(
            0x2aa447eea17a94e7fbfaa3d87ccaa0388a93f9e887f4d660cd60be7c65344065,
            0x1fd621111aef4d50dad9b795b3a9511983ae737108ef5a65c0b2112edbd2e6f0
        );
        vk.C = Pairing.G2Point(
            [
                0x181346e86f03be7b44d63438ef8cc68ecfc7d546d7afb8e9037ae2af99f96336,
                0x160f553a578000d0c0296fee11325f6ae5527970740f71ab318909274f1a5f6e
            ],
            [
                0x2b487a39512310bd75d47236824bb1a20e004a1d2ba44e762ce8146702b14aa3,
                0x26a7d8fd39b4daa9b4533fdc0a30a641da8c22fe2504ad2bd143f025dad4c5b5
            ]
        );
        vk.gamma = Pairing.G2Point(
            [
                0x172f4ddecff140107533942084e6af13412777cc1ee923659f269e6c473e3ed6,
                0x1730397c7d01a02c2acb2afcd89359044fe3bd8865843e80154f2f5299490ac3
            ],
            [
                0x1c1d68518cbd23622999fe973ada84585e3e2b2bac8760333e11cd5ef5c686cc,
                0x28d679bd0d817e11b9f34de6c5ec6213d417fc58782208065bbf815c0cfa7d45
            ]
        );
        vk.gammaBeta1 = Pairing.G1Point(
            0x7a3940d4e762e081fb1dd549f8f5025b394346ace0c04e8fdd60880b4a5d93,
            0x273a36e4e39723b7ed267fa703fe1542b5266c8d66c03687698742d8c1934569
        );
        vk.gammaBeta2 = Pairing.G2Point(
            [
                0x20a77805430eb464e729bab6417ba0f4ef7bb43ff34702db6f1d1929066e2b95,
                0xfc3da72fb184621161e1431e97c1d92a959f714c684d42e64035b6157a540c1
            ],
            [
                0x29d89722d3da0e6bc495cfa26a9c62c1a9deda680b385cfe22175debea095ac4,
                0x23351dc1be4759c7521af61aa42e2690a9c7bfbdb19cf556462fe16edad7549e
            ]
        );
        vk.Z = Pairing.G2Point(
            [
                0x100f3fbb2d7e67990d940b09dbf95c411707285947cc3a6fd51427634749914a,
                0x2a769cc5a868d9e2b9a86cfd382d54918afe7900c53f54706acef09540bec366
            ],
            [
                0x1268f992f4ef4307b3976ab3f0a666da996b61069c986a3489034a0d7999294b,
                0xf4193f2e30d9916b08852f05496ab2faa2ff93b0b7b1c418c5223bd426a4b28
            ]
        );
        vk.IC = new Pairing.G1Point[](3);
        vk.IC[0] = Pairing.G1Point(
            0xa1ee3eca13e64d46429399acbf6589f50e12b19008abefcdf2421d03d74ec58,
            0x1b8d1f5e50860ae1d1b552b69e4c292c261e0038c6695c504ac88a78a0870254
        );
        vk.IC[1] = Pairing.G1Point(
            0x2d2ce079657b043552a395ad6d2ef452afe415db6a8ecc22002b06e39be6131d,
            0x5cd2e8c95994c1b747d76c69bdf9c51a4122fb741b69efc4db8c9d33ef6d1b0
        );
        vk.IC[2] = Pairing.G1Point(
            0x109d9df2b9b48754d085850979cc5526ca266b47bc33f87b6fd8a7d1d5ddbe98,
            0x248afa30013d59896e9ce49cedddaab84ddab8e3cba1b246d9a7aceb13fca74a
        );
    }

    function verify(uint256[] memory input, Proof memory proof)
        internal
        returns (uint256)
    {
        VerifyingKey memory vk = verifyingKey();
        require(input.length + 1 == vk.IC.length);
        // Compute the linear combination vk_x
        Pairing.G1Point memory vk_x = Pairing.G1Point(0, 0);
        for (uint256 i = 0; i < input.length; i++)
            vk_x = Pairing.addition(
                vk_x,
                Pairing.scalar_mul(vk.IC[i + 1], input[i])
            );
        vk_x = Pairing.addition(vk_x, vk.IC[0]);
        if (
            !Pairing.pairingProd2(
                proof.A,
                vk.A,
                Pairing.negate(proof.A_p),
                Pairing.P2()
            )
        ) return 1;
        if (
            !Pairing.pairingProd2(
                vk.B,
                proof.B,
                Pairing.negate(proof.B_p),
                Pairing.P2()
            )
        ) return 2;
        if (
            !Pairing.pairingProd2(
                proof.C,
                vk.C,
                Pairing.negate(proof.C_p),
                Pairing.P2()
            )
        ) return 3;
        if (
            !Pairing.pairingProd3(
                proof.K,
                vk.gamma,
                Pairing.negate(
                    Pairing.addition(vk_x, Pairing.addition(proof.A, proof.C))
                ),
                vk.gammaBeta2,
                Pairing.negate(vk.gammaBeta1),
                proof.B
            )
        ) return 4;
        if (
            !Pairing.pairingProd3(
                Pairing.addition(vk_x, proof.A),
                proof.B,
                Pairing.negate(proof.H),
                vk.Z,
                Pairing.negate(proof.C),
                Pairing.P2()
            )
        ) return 5;
        return 0;
    }

    event Verified(string s);

    function verifyTx(
        uint256[2] memory a,
        uint256[2] memory a_p,
        uint256[2][2] memory b,
        uint256[2] memory b_p,
        uint256[2] memory c,
        uint256[2] memory c_p,
        uint256[2] memory h,
        uint256[2] memory k,
        uint256[2] memory input
    ) public returns (bool r) {
        Proof memory proof;
        proof.A = Pairing.G1Point(a[0], a[1]);
        proof.A_p = Pairing.G1Point(a_p[0], a_p[1]);
        proof.B = Pairing.G2Point([b[0][0], b[0][1]], [b[1][0], b[1][1]]);
        proof.B_p = Pairing.G1Point(b_p[0], b_p[1]);
        proof.C = Pairing.G1Point(c[0], c[1]);
        proof.C_p = Pairing.G1Point(c_p[0], c_p[1]);
        proof.H = Pairing.G1Point(h[0], h[1]);
        proof.K = Pairing.G1Point(k[0], k[1]);
        uint256[] memory inputValues = new uint256[](input.length);
        for (uint256 i = 0; i < input.length; i++) {
            inputValues[i] = input[i];
        }
        if (verify(inputValues, proof) == 0) {
            emit Verified("Transaction successfully verified.");
            return true;
        } else {
            return false;
        }
    }
}
