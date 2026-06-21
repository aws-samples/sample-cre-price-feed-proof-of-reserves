# Digital Asset Price Feeds & Proof of Reserves (PoR): Integrating AWS with Chainlink Runtime Environment (CRE) Workflows 

**Authored by: Simon Goldberg**

## Overview

This project demonstrates workflows using the Chainlink Runtime Environment to fetch data from AWS serverless APIs and write results to Ethereum smart contracts. 

The system combines AWS reliability with decentralized trust guarantees to support digital asset price feeds and proof-of-reserves monitoring.

## Architecture

![Architecture Diagram](./architecture.png)

## Use Cases

- **Price feeds for DeFi protocols**: Low-latency, tamper-resistant pricing data for lending, derivatives, and AMMs with decentralized verification.
- **Proof-of-reserves monitoring**: Continuous verification that stablecoins and wrapped assets are fully backed by underlying reserves.
- **Custom data feeds**: Configurable, multi-source data feeds for tokenized assets. 
  
## Components

- **AWS Serverless Backend** - REST API with Lambda and DynamoDB for oracle data storage ([Setup Guide](../price-feed-por-dynamodb-crud/README.md))
- **CRE Workflows** - Go-based workflow for data fetching and contract updates ([Setup Guide](../aws-oracle-cre/README.md))
- **Smart Contracts** - PriceFeed and CollateralizationMonitor contracts on Ethereum Sepolia ([Contract Guide](../aws-oracle-cre/contracts/evm/README.md))

## Prerequisites

- **AWS CLI** - Configured with credentials ([Installation](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html))
- **AWS SAM CLI** - For serverless deployment ([Installation](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/install-sam-cli.html))
- **CRE CLI** - v1.0.3+ ([Installation](https://docs.chain.link/cre/getting-started/cli-installation))
  - After installation, authenticate with `cre login`
  - Verify authentication with `cre whoami`
- **Node.js** - 20+ for AWS Lambda functions
- **Go** - 1.25.3+ for CRE workflows
- **Sepolia ETH** - For contract deployment and transactions ([Get testnet ETH at a public faucet](https://faucets.chain.link))

> **Windows Users:** This sample uses Bash scripts and Unix tools. Please run deployments using WSL2.

## Quick Start

### Automated Deployment (Recommended)

Clone the repository and deploy everything with a single script:

```bash
git clone https://github.com/aws-samples/sample-cre-pricefeeds-por.git
cd sample-cre-pricefeeds-por
./deploy-all.sh
```

This automates:
- AWS infrastructure deployment (Lambda, API Gateway, DynamoDB)
- Smart contract deployment to Sepolia
- CRE workflow configuration and testing

See the below for details and deeper dives.

### Manual Deployment

#### 1. Deploy AWS Backend
Deploy the serverless REST API with Lambda and DynamoDB. See [AWS Backend README](../price-feed-por-dynamodb-crud/README.md) for complete setup instructions.

#### 2. Setup and Run CRE Workflow
Configure and run the CRE workflow to fetch data from AWS and update smart contracts on Ethereum Sepolia. See [CRE Workflow README](../aws-oracle-cre/README.md) for complete setup instructions, including smart contract deployment and configuration.

> **Note:** CRE is also available in TypeScript. For TypeScript implementation details, refer to the [CRE documentation](https://docs.chain.link/cre).

## Documentation

- [AWS Backend Setup](../price-feed-por-dynamodb-crud/README.md)
- [CRE Workflow Setup](../aws-oracle-cre/README.md)
- [Smart Contract Deployment](../aws-oracle-cre/contracts/evm/README.md)

## Technology Stack

- **Chainlink CRE** - v1.0.3 (Workflow orchestration)
- **AWS SAM** - Infrastructure as Code
- **Amazon API Gateway** - Managed API service for HTTP/REST endpoints Lambda integation and authorization 
- **AWS Lambda** - Serverless compute
- **AWS DynamoDB** - NoSQL database
- **Solidity** - Smart contracts
- **Foundry** - Contract development
- **Go** - Workflow implementation

## Security

See [CONTRIBUTING](CONTRIBUTING.md#security-issue-notifications) for more information.

## License

This library is licensed under the MIT-0 License. See the LICENSE file.
