#!/bin/bash -x

#RPC_URL="https://api.mainnet-beta.solana.com"
RPC_URL="http://***"
KEYPAIR_PATH="~/.config/solana/id.json"


check_rewards() {
    rewards_output=$(ore --rpc $RPC_URL --keypair $KEYPAIR_PATH rewards)
    echo "Rewards output: $rewards_output"

    reward=$(echo $rewards_output| awk -F ' ' '{print $1}')
    echo $reward
    reward_threshold=0.02
    if (( $(echo "$reward > $reward_threshold" | bc -l) )); then
        echo "Reward of $reward ORE is greater than threshold. Claiming rewards..."
        ore --rpc $RPC_URL --keypair $KEYPAIR_PATH --priority-fee 100 claim
    else
        echo "Reward of $reward ORE is not greater than threshold. No action taken."
    fi
}

while true; do
    check_rewards
    sleep 1200
done
