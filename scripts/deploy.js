async function main() {
  const [deployer] = await ethers.getSigners()

  console.log('Deploying contracts with the account:', deployer.address)

  console.log('Account balance:', (await deployer.getBalance()).toString())

  const Contract = await ethers.getContractFactory(process.env.CONTRACT_NAME)
  // contract constructor arguments can be passed as parameters in #deploy
  // await Contract.deploy(arg1, arg2, ...)
  // TODO: make configurable through CLI params
  const contract = await Contract.deploy(
    // goerli
    // HyperbolicProtocol
    '0x0A3C6F5CCe52B9Ff2FFA0371146D1DB8AA84B703',
    '0xC36442b4a4522E871399CD717aBDD847Ab11FE88',
    '0xE592427A0AEce92De3Edee1F18E0157C05861564',
    '0x1F98431c8aD98523631AE4a59f267346ea31F984',
    '0xB4FBF271143F4FBf7B91A5ded31805e42b2208d6'
    // LendingPool
    // 'https://api.hyperbolicprotocol.com/loans/metadata/',
    // '',
    // '0x0A3C6F5CCe52B9Ff2FFA0371146D1DB8AA84B703',
    // '0x719722662A467105420a55D36063B10558a3Efde',
    // '0xB4FBF271143F4FBf7B91A5ded31805e42b2208d6'

    // sepolia
    // HyperbolicProtocol
    // '0xd9b6F6e53c60802d278efE0C643D9C01BBd93abc',
    // '',
    // '',
    // '',
    // ''

    // arbitrum
    // HyperbolicProtocol
    // '0xdf9a6debb35be847d6addb7843e763539671b2c7',
    // '0xC36442b4a4522E871399CD717aBDD847Ab11FE88',
    // '0xE592427A0AEce92De3Edee1F18E0157C05861564',
    // '0x1F98431c8aD98523631AE4a59f267346ea31F984',
    // '0x82aF49447D8a07e3bd95BD0d56f35241523fBab1'
    // LendingPool
    // 'https://api.hyperbolicprotocol.com/loans/metadata/',
    // '0xE592427A0AEce92De3Edee1F18E0157C05861564',
    // '0x85225Ed797fd4128Ac45A992C46eA4681a7A15dA',
    // '0xdf9a6debb35be847d6addb7843e763539671b2c7',
    // '0x300648a601c584E6379fa0D6a31CbBFCcA6177e4',
    // '0x82aF49447D8a07e3bd95BD0d56f35241523fBab1'
    // LendingPoolExtLP
    // 'https://api.hyperbolicprotocol.com/loans/ext/metadata/',
    // '0xE592427A0AEce92De3Edee1F18E0157C05861564',
    // '0x85225Ed797fd4128Ac45A992C46eA4681a7A15dA',
    // '0xdf9a6debb35be847d6addb7843e763539671b2c7',
    // '0x300648a601c584E6379fa0D6a31CbBFCcA6177e4',
    // '0x82aF49447D8a07e3bd95BD0d56f35241523fBab1'

    // eth
    // '0xBf1858b24243Ecbcf7d940f458e36CB7401c2366',
    // '0xC36442b4a4522E871399CD717aBDD847Ab11FE88',
    // '0xE592427A0AEce92De3Edee1F18E0157C05861564',
    // '0x1F98431c8aD98523631AE4a59f267346ea31F984',
    // '0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2'
    // LendingPool
    // 'https://api.hyperbolicprotocol.com/loans/metadata/',
    // '0xE592427A0AEce92De3Edee1F18E0157C05861564',
    // '0x85225Ed797fd4128Ac45A992C46eA4681a7A15dA',
    // '0xBf1858b24243Ecbcf7d940f458e36CB7401c2366',
    // '0x300648a601c584E6379fa0D6a31CbBFCcA6177e4',
    // '0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2'
    // LendingPoolExtLP
    // 'https://api.hyperbolicprotocol.com/loans/ext/metadata/',
    // '0xE592427A0AEce92De3Edee1F18E0157C05861564',
    // '0x85225Ed797fd4128Ac45A992C46eA4681a7A15dA',
    // '0xBf1858b24243Ecbcf7d940f458e36CB7401c2366',
    // '0x300648a601c584E6379fa0D6a31CbBFCcA6177e4',
    // '0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2'
  )

  console.log('Contract address:', contract.address)
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error)
    process.exit(1)
  })
