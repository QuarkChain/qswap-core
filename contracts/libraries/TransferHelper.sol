// SPDX-License-Identifier: GPL-3.0-or-later

pragma solidity >=0.5.16;

import './NativeToken.sol';

library TransferHelper {
    function safeTransfer(uint token, address to, uint value) internal {
        bytes memory data = NativeToken.transferToken(to, token, value, 0);
        require(data.length == 0 || abi.decode(data, (bool)), 'UniswapV2: TRANSFER_FAILED');
    }
}
