const { BN, constants, expectEvent, expectRevert,  } = require('@openzeppelin/test-helpers');
const { ZERO_ADDRESS } = constants;
const { shouldSupportInterfaces } = require('../../../utils/introspection/SupportsInterface.behavior');
const { expect } = require('chai');
const EyeLid = artifacts.require('EyeLid');

contract('EyeLid', async accounts => {
  const DEFAULT_ADMIN_ROLE = '0x0000000000000000000000000000000000000000000000000000000000000000';
  const MINTER_ROLE = web3.utils.soliditySha3('MINTER_ROLE');
  const PAUSER_ROLE = web3.utils.soliditySha3('PAUSER_ROLE');
  const [ deployer, other ] = accounts;
  const firstWorldPop = 1;
  const secondWorldPop = 2;
  const uri = 'https://EyeLid.com';
  
  before(async function () {
    this.token = await EyeLid.new(uri, { from: deployer });
  });  

  shouldSupportInterfaces(['ERC1155', 'AccessControl', 'AccessControlEnumerable']);
  
  it('deployer has the default admin role', async function () {
    expect(await this.token.getRoleMemberCount(DEFAULT_ADMIN_ROLE)).to.be.bignumber.equal('1');
    expect(await this.token.getRoleMember(DEFAULT_ADMIN_ROLE, 0)).to.equal(deployer);
  });

  it('deployer can increase population', async function () {
    await this.token.setWorldPop(firstWorldPop,{ from: deployer });
  });

  it('population can only increase', async function () {
    await expectRevert(
    this.token.setWorldPop((firstWorldPop-1), { from: deployer }),
    'EyeLid: population can only be increased',
    );
  });

  it('other accounts cannot increase population', async function () {
    await expectRevert(
    this.token.setWorldPop(secondWorldPop, { from: other }),
    'EyeLid: must have admin role to change population',
    );
  });

  it('cannot mint eyecon + eyecoins without fee', async function () {
    await expectRevert(
    this.token.mintEyecon({ from: other, value: 0 }),
    'EyeLid: please include the current price with your request',
    );
  });

  it('other accounts can mint eyecon + eyecoins', async function () {
    const receipt = await this.token.mintEyecon({ from: other, value: 79000000000000000 });
    expectEvent(receipt, 'TransferBatch', { operator: other, from: ZERO_ADDRESS, to: other },
    );
  });

  it('cannot mint more eyecons than current world population', async function () {
    await expectRevert(
    this.token.mintEyecon({ from: other, value: 79000000000000000 }),
    'EyeLid: world population set too low to mint more',
    );
  });

  it('other accounts cannot change artist', async function () {
    await expectRevert(
    this.token.setArtist( other, { from: other }),
    'EyeLid: must have admin role to change artist',
    );
  });

  it('deployer can change artist', async function () {
    expect(await this.token.setArtist( other, { from: deployer }));
  });

  it('other accounts cannot change price', async function () {
    await expectRevert(
    this.token.setPrice(1, { from: other }),
    'EyeLid: must have admin role to change price',
    );
  });

  it('deployer can change price', async function () {
    await this.token.setPrice(1, { from: deployer });
  });

});