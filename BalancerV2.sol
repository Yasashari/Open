function querySwap(IBalancerVault.SingleSwap memory singleSwap) public returns (uint256) {
        // The Vault only supports batch swap queries, so we need to convert the swap call into an equivalent batch
        // swap. The result will be identical.

        // The main difference between swaps and batch swaps is that batch swaps require an assets array. We're going
        // to place the asset in at index 0, and asset out at index 1.
        address[] memory assets = new address[](2);
        assets[0] = singleSwap.assetIn;
        assets[1] = singleSwap.assetOut;

        IBalancerVault.BatchSwapStep[] memory swaps = new IBalancerVault.BatchSwapStep[](1);
        swaps[0] = IBalancerVault.BatchSwapStep({
            poolId: singleSwap.poolId,
            assetInIndex: 0,
            assetOutIndex: 1,
            amount: singleSwap.amount,
            userData: singleSwap.userData
        });

        IBalancerVault.FundManagement memory funds = IBalancerVault.FundManagement({
            sender: address(0),
            fromInternalBalance: false,
            recipient: address(0),
            toInternalBalance: false
        });

        int256[] memory assetDeltas = queryBatchSwap(singleSwap.kind, swaps, assets, funds);

        // Batch swaps return the full Vault asset deltas, which in the special case of a single step swap contains more
        // information than we need (as the amount in is known in a GIVEN_IN swap, and the amount out is known in a
        // GIVEN_OUT swap). We extract the information we're interested in.
        if (singleSwap.kind == IBalancerVault.SwapKind.GIVEN_IN) {
            // The asset out will have a negative Vault delta (the assets are coming out of the Pool and the user is
            // receiving them), so make it positive to match the `swap` interface.

            require(assetDeltas[1] <= 0, "SHOULD_NOT_HAPPEN");
            return uint256(-assetDeltas[1]);
        } else {
            // The asset in will have a positive Vault delta (the assets are going into the Pool and the user is
            // sending them), so we don't need to do anything.
            return uint256(assetDeltas[0]);
        }
    }

    function queryBatchSwap(
        IBalancerVault.SwapKind kind,
        IBalancerVault.BatchSwapStep[] memory swaps,
        address[] memory assets,
        IBalancerVault.FundManagement memory funds
    ) public returns (int256[] memory assetDeltas) {
        (, bytes memory returnData) = address(vault).call(
            abi.encodeWithSelector(
                IBalancerVault.queryBatchSwap.selector,
                kind,
                swaps,
                assets,
                funds
            )
        );
        assetDeltas = abi.decode(returnData, (int256[]));
        require(assetDeltas.length == swaps.length.add(1), "Unexpected length");
    }
}
