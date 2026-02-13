Deterministic Yield Router

A predictable and transparent yield allocation smart contract built on the **Stacks blockchain using Clarity**.

The **Deterministic Yield Router** enables structured routing of deposited assets into predefined yield strategies using fixed allocation weights. Unlike discretionary yield systems, this contract enforces deterministic mathematical rules for capital allocation and reward distribution.

---

Overview

The Deterministic Yield Router is designed to:

- Route deposits across multiple strategies using fixed weights
- Ensure transparent and verifiable yield calculations
- Maintain deterministic reward accounting
- Provide composability with vaults, DAOs, and treasury systems
- Pass `clarinet check` with clean architecture

This contract is ideal for DeFi protocols seeking predictable yield infrastructure without off-chain allocation logic.

---

Architecture

```
User Deposit
      │
      ▼
Deterministic Yield Router
      │
      ├── Strategy A (Weight 40%)
      ├── Strategy B (Weight 35%)
      └── Strategy C (Weight 25%)
```

All routing logic is handled on-chain using predefined allocation ratios.

---

Features

- Deterministic deposit routing
- Fixed allocation weights per strategy
- Proportional reward distribution
- Admin-controlled strategy configuration
- Transparent on-chain accounting
- Read-only analytics functions
- Fully compatible with Clarinet tooling

---

Core Functions

Public Functions

- `deposit(amount)`
  - Routes funds to strategies based on weight configuration.

- `withdraw(amount)`
  - Withdraws user’s proportional share across strategies.

- `claim-rewards()`
  - Claims accumulated yield rewards.

- `set-strategy-weight(strategy, weight)`
  - Updates allocation weight (admin only).

- `add-strategy(strategy, weight)`
  - Registers a new yield strategy (admin only).

- `remove-strategy(strategy)`
  - Removes a strategy from routing (admin only).

---

Read-Only Functions

- `get-user-share(user)`
- `get-total-routed()`
- `get-strategy-weight(strategy)`
- `calculate-rewards(user)`
- `get-total-strategies()`

---

Deterministic Allocation Model

Allocation is calculated as:

```
Strategy Allocation = (Deposit Amount × Strategy Weight) / Total Weight
```

Rewards are distributed proportionally:

```
User Reward = (User Share / Total Routed Capital) × Total Yield
```

No randomization or discretionary logic is involved.

---

Security Considerations

- Allocation weights validated to prevent overflow
- Strict admin-only configuration functions
- Deterministic arithmetic prevents manipulation
- Clear separation between router and strategy contracts
- Designed for audit-readiness
- No hidden minting or reward inflation logic

---

Development & Testing

Requirements

- Clarinet
- Stacks CLI

Check Contract

```bash
clarinet check
```

Run Tests

```bash
clarinet test
```

---

Use Cases

- DAO treasury yield routing
- Structured DeFi vault systems
- Institutional capital allocation frameworks
- Multi-strategy farming aggregators
- Predictable staking reward systems

---

 Upgrade Strategy

This contract is designed to be modular:

- Strategies can be added or removed
- Allocation weights can be updated
- Router logic remains deterministic

For upgradeable architecture, integrate with a governance-controlled proxy pattern.

---

Advantages Over Traditional Yield Routers

| Feature | Deterministic Router | Traditional Router |
|----------|----------------------|--------------------|
| Allocation Transparency | Fully On-Chain | Often Off-Chain |
| Predictability | Fixed Rules | Variable |
| Audit Simplicity | High |  Medium |
| Governance Control | Structured | Flexible but complex |

---

License

MIT License

---

Author

Built for secure and predictable yield infrastructure on the Stacks blockchain.

---

