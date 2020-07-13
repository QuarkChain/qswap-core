pragma solidity >=0.5.16;

library NativeToken {

    /**
     * @dev Returns native token ID in current transaction.
     */
    function getCurrentToken() internal view returns (uint256) {
        uint256[1] memory output;
        assembly {
            // Gas cost: 3.
            if iszero(staticcall(3, 0x514b430001, 0, 0x00, output, 0x20)) {
                revert (0, 0)
            }
        }
        return output[0];
    }

    /**
     * @dev Returns native token balance for the given address and token.
     */
    function getTokenBalance(address target, uint256 tokenId) internal view returns (uint256) {
        uint256[1] memory output;
        uint256[2] memory input;

        input[0] = uint256(target);
        input[1] = tokenId;

        assembly {
            // Gas cost: 400.
            if iszero(staticcall(400, 0x514b430005, input, 0x40, output, 0x20)) {
                revert (0, 0)
            }
        }
        return output[0];
    }

    /**
     * @dev Transfers native tokens for the given address, token and value.
     *  TODO: should also support data field.
     */
    function transferToken(address to, uint256 tokenId, uint256 value, uint256 resultLen) internal returns (bytes memory) {
        // TODO: should support custom data in the future.
        bytes memory output = new bytes(resultLen);
        uint256[3] memory input;
        input[0] = uint256(to);
        input[1] = tokenId;
        input[2] = value;

        assembly{
            if iszero(call(not(0), 0x514b430002, 0, input, 0x60, output, resultLen)){
                revert(0, 0)
            }
        }
        return output;
    }
}

interface AllowNonDefaultNativeToken {
    /**
     * @dev This modifier is needed if the contract wants to allow transactions with `transfer_token_id`
     * is not default.
     */
    modifier allowToken() {
        NativeToken.getCurrentToken();
        _;
    }
}
