pragma solidity ^0.4.8;
contract MarketBank {
    //
    // Author : Skryptek 
    // email : RealmKoin@gmail.com 
    // Version : 1.0 - initial release
    // GitHub : https://github.com/RealmKoin
    //
    // 
    // This smart contract requires a fee to use to use but donations to the RK project are always welcome also :
    //   Donate Ether / Tokens - 0xdb436485f38d0f9c78acfb20ededc97419eb2ea5
    //
    /* -------- State data -------- */
    address private _owner;
    uint256 private _marketDonationsBalance = 0;
    bool private _connectMarketAccountToNewOwnerAddressEnabled = true;
    uint private Number_For_Account_Input;
    string private _NeedToMakeAccountToPostListing;
    string private _NeedToMakeAccountToFillListing;
    uint256 private _Balance_From_Input;
    uint private _Sellers_Address;
    Order_Data[] public OData;
    Purchase_Data[] public Data;
    uint private value;
    address seller;
    address buyer;
    uint _index;
    uint _Id_Number;
    address _Seller_Address;
    string _Currency_Used;
    uint _Buyers_Address;
    string _Abort_Event;
    string _Purchase_Initiated_Event;
    string _Item_Delivered_Event;
    string _Ethereum_Listing_Event;
    string _Realmkoin_Listing_Event;
    uint256 _funds2;
    address _destination_Account;
    uint _destinationAccount;
    uint _FirstAccount;
    uint _SecondAccount;
    /// Skryptek Note ~ '==' operator can not be used with string for condition(_Checksum), formatting to integer
    /// 10 = 'Active'
    /// 15 = 'Yes'
    /// 20 = 'Inactive'
    /// 30 = 'Closed'
   // Structure For Order Data
    struct Order_Data {
        uint Buyers_Address;
        uint Value_Paid;
        uint256 Escrow_Held;
        uint Lich_Room_Number;
        string Recipient_Character;
    }
    // Structure For Purchase Data
    struct Purchase_Data {
        uint index;
        uint Post_ID_Number;
        string Item_Name;
        uint Posters_Address;
        uint Transaction_Value_Of_Post;
        uint value;
        string Item_Description;
        string Currency_Used;
        uint Contract_State;
    }
    // Structure For Market accounts array : MarketAccount[] <-- Unmapped / 'Empty'
    struct MarketAccount
    {
        // Members placed in order for optimization, not readability
        bool passwordSha3HashSet;
        uint32 number; 
        uint32 passwordAttempts;
        uint256 balance;
        address owner;       
        bytes32 passwordSha3Hash;
        uint256 Escrow_Held;
        uint256 Escrow_Locked;
        uint256 Escrow_Unlocked;
        mapping(bytes32 => bool) passwordSha3HashesUsed; // MarketAccount[passwordSha3HashesUsed[bytes32].bool] <-- Double Mapped Structure
    }   
    // Structure For Market account address's array : MarketAccountAddress[address]._marketAccountAddresses <-- Mapped 
    struct MarketAccountAddress
    {
        bool accountSet;
        uint32 accountNumber; // accountNumber member is used to index the market accounts array
    }
    uint32 private _totalMarketAccounts = 0;
    MarketAccount[] private _marketAccountsArray; 
    mapping(address => MarketAccountAddress) private _marketAccountAddresses;  // Mapping For MarketAccountAddress[address]
    /* -------- Constructor -------- */
    function MarketBank() public
    {
        // Set the contract owner
        _owner = msg.sender; 
    }
    /* -------- Events -------- */
    // Shop
    event RealmKoin_Listing(string _Realmkoin_Listing_Event);
    event Ethereum_Listing(string _Ethereum_Listing_Event);
    event Aborted(string _Abort_Event); /// Event Fills In Args When Called
    event Initiated_Purchase(string _Purchase_Initiated_Event); /// Event Fills In Args When Called
    event Item_Delivered(string _Item_Delivered_Event); /// Event Fills In Args When Called
    // Donation
    event event_donationMadeToMarket_ThankYou(uint256 donationAmount);
    event event_realmKoinDonated_To_Benificiary(uint256 donationAmount);
    event event_getMarketDonationsBalance(uint256 donationBalance);
    event event_marketDonationsWithdrawn(uint256 donationsAmount);
    // General market banking
    event event_UnlockFromEscrowAccount_Successful(uint indexed marketAccountNumber_escrow2, uint256 indexed depositAmount, uint indexed marketAccountNumber_escrow); 
    event event_UnlockFromEscrowAccount_Failed(uint indexed marketAccountNumber2, uint256 indexed depositAmount, uint indexed marketAccountNumber); 
    event event_RefundFromEscrowAccount_Successful(uint indexed marketAccountNumber_escrow2, uint256 indexed depositAmount); 
    event event_RefundFromEscrowAccount_Failed(uint indexed marketAccountNumber2, uint256 indexed depositAmount); 
    event event_ReleaseFromEscrowAccount_Successful(uint indexed marketAccountNumber_escrow2, uint256 indexed depositAmount, uint indexed marketAccountNumber_escrow); 
    event event_ReleaseFromEscrowAccount_Failed(uint indexed marketAccountNumber2, uint256 indexed depositAmount, uint indexed marketAccountNumber); 
    event event_depositMadeToEscrowAccount_Successful(uint indexed marketAccountNumber, uint256 indexed depositAmount); 
    event event_depositMadeToEscrowAccount_Failed(uint indexed marketAccountNumber, uint256 indexed depositAmount); 
    event input_event_getMarketAccountBalance_Successful(uint indexed marketAccountNumber, uint256 indexed balance);
    event event_marketAccountOpened_Successful(address indexed marketAccountOwner, uint32 indexed marketAccountNumber, uint256 indexed depositAmount);
    event event_getMarketAccountNumber_Successful(uint32 indexed marketAccountNumber);
    event event_getMarketAccountBalance_Successful(uint32 indexed marketAccountNumber, uint256 indexed balance);
    event event_depositMadeToMarketAccount_Successful(uint32 indexed marketAccountNumber, uint256 indexed depositAmount); 
    event event_depositMadeToMarketAccount_Failed(uint32 indexed marketAccountNumber, uint256 indexed depositAmount); 
    event event_depositMadeToMarketAccountFromDifferentAddress_Successful(uint32 indexed marketAccountNumber, address indexed addressFrom, uint256 indexed depositAmount);
    event event_depositMadeToMarketAccountFromDifferentAddress_Failed(uint32 indexed marketAccountNumber, address indexed addressFrom, uint256 indexed depositAmount);
    event event_withdrawalMadeFromMarketAccount_Successful(uint32 indexed marketAccountNumber, uint256 indexed withdrawalAmount); 
    event event_withdrawalMadeFromMarketAccount_Failed(uint32 indexed marketAccountNumber, uint256 indexed withdrawalAmount); 
    event event_transferMadeFromMarketAccountToAddress_Successful(uint32 indexed marketAccountNumber, uint256 indexed transferalAmount, address indexed destinationAddress); 
    event event_transferMadeFromMarketAccountToAddress_Failed(uint32 indexed marketAccountNumber, uint256 indexed transferalAmount, address indexed destinationAddress); 
    event event_NeedToMakeAccountToPostListing(string _NeedToMakeAccountToPostListing);
    event event_NeedToMakeAccountToFillListing(string _NeedToMakeAccountToFillListing);
    event event_transferMadeFromMarketAccountToMarketAccount_Successful(uint indexed marketAccountNumber, uint256 indexed transferalAmount, uint indexed destinationAddress); 
    event event_transferMadeFromMarketAccountToMarketAccount_Failed(uint indexed marketAccountNumber, uint256 indexed transferalAmount, uint indexed destinationAddress); 
    // Security
    event event_securityConnectingAMarketAccountToANewOwnerAddressIsDisabled();
    event event_securityHasPasswordSha3HashBeenAddedToMarketAccount_Yes(uint32 indexed marketAccountNumber);
    event event_securityHasPasswordSha3HashBeenAddedToMarketAccount_No(uint32 indexed marketAccountNumber);
    event event_securityPasswordSha3HashAddedToMarketAccount_Successful(uint32 indexed marketAccountNumber);
    event event_securityPasswordSha3HashAddedToMarketAccount_Failed_PasswordHashPreviouslyUsed(uint32 indexed marketAccountNumber);
    event event_securityMarketAccountConnectedToNewAddressOwner_Successful(uint32 indexed marketAccountNumber, address indexed newAddressOwner);
    event event_securityMarketAccountConnectedToNewAddressOwner_Failed_PasswordHashHasNotBeenAddedToMarketAccount(uint32 indexed marketAccountNumber);
    event event_securityMarketAccountConnectedToNewAddressOwner_Failed_SentPasswordDoesNotMatchAccountPasswordHash(uint32 indexed marketAccountNumber, uint32 indexed passwordAttempts);
    event event_securityGetNumberOfAttemptsToConnectMarketAccountToANewOwnerAddress(uint32 indexed marketAccountNumber, uint32 indexed attempts);
    /* -------- Modifiers -------- */
    modifier modifier_isContractOwner(){
        // Contact owner?
        if (msg.sender != _owner){
            throw;       
        }
        _;
    }
    modifier condition(bool _condition) {
        require(_condition);
        _;
    }
    modifier echo_fill_modifier_doesSenderHaveAMarketAccount(){ 
        // Does this sender have a market account?
        if (_marketAccountAddresses[msg.sender].accountSet == false){
            _NeedToMakeAccountToFillListing = 'You Need To Use Create_Market_Account() To Fill Listings.';
            event_NeedToMakeAccountToFillListing(_NeedToMakeAccountToFillListing);
            throw;
        }
        else {
            // Does the market account owner address match the sender address?
            uint32 accountNumber_ = _marketAccountAddresses[msg.sender].accountNumber;
            if (msg.sender != _marketAccountsArray[accountNumber_].owner){
                // Sender address previously had a market account that was transfered to a new owner address
                throw;        
            }
        }
        _;
    }
    modifier input_modifier_doesSenderHaveAMarketAccount(address _Account_For_Number){ 
        // Does this sender have a market account?
        if (_marketAccountAddresses[_Account_For_Number].accountSet == false){
            _NeedToMakeAccountToPostListing = 'This Address Has No Account.';
            event_NeedToMakeAccountToPostListing(_NeedToMakeAccountToPostListing);
            throw;
        }
        else {
            // Does the market account owner address match the sender address?
            uint32 accountNumber_ = _marketAccountAddresses[_Account_For_Number].accountNumber;
            if (msg.sender != _marketAccountsArray[accountNumber_].owner){
                // Sender address previously had a market account that was transfered to a new owner address
                throw;        
            }
        }
        _;
    }
    modifier echo_post_modifier_doesSenderHaveAMarketAccount(){ 
        // Does this sender have a market account?
        if (_marketAccountAddresses[msg.sender].accountSet == false){
            _NeedToMakeAccountToPostListing = 'You Need To Use Create_Market_Account() To Create Listings.';
            event_NeedToMakeAccountToPostListing(_NeedToMakeAccountToPostListing);
            throw;
        }
        else {
            // Does the market account owner address match the sender address?
            uint32 accountNumber_ = _marketAccountAddresses[msg.sender].accountNumber;
            if (msg.sender != _marketAccountsArray[accountNumber_].owner){
                // Sender address previously had a market account that was transfered to a new owner address
                throw;        
            }
        }
        _;
    }
    modifier modifier_doesSenderHaveAMarketAccount(){ 
        // Does this sender have a market account?
        if (_marketAccountAddresses[msg.sender].accountSet == false){
            throw;
        }
        else {
            // Does the market account owner address match the sender address?
            uint32 accountNumber_ = _marketAccountAddresses[msg.sender].accountNumber;
            if (msg.sender != _marketAccountsArray[accountNumber_].owner){
                // Sender address previously had a market account that was transfered to a new owner address
                throw;        
            }
        }
        _;
    }
    modifier only_buyer(uint index) {
        Input_GetMarketAccountNumber(msg.sender);
        require(Number_For_Account_Input == OData[index].Buyers_Address);
        _;
    }
    modifier only_seller(uint index) {
        Input_GetMarketAccountNumber(msg.sender);
        require(Number_For_Account_Input == Data[index].Posters_Address);
        _;
    }
    modifier modifier_wasValueSent(){ 
        // Value sent?
        if (msg.value > 0){
            // Prevent users from sending value accidentally
            throw;        
        }
        _;
    }
    /* -------- Contract owner functions -------- */
    function Donate() public payable
    {
        if (msg.value > 0)
        {    
            uint amount = msg.value;
            _marketDonationsBalance += msg.value;
            event_donationMadeToMarket_ThankYou(msg.value);
        }
    }
    function MarketOwner_GetDonationsBalance() public      
        modifier_isContractOwner()
        modifier_wasValueSent()
        returns (uint256)
    {
        event_getMarketDonationsBalance(_marketDonationsBalance);
  	    return _marketDonationsBalance;
    }
    function MarketOwner_WithdrawDonations() public
        modifier_isContractOwner()
        modifier_wasValueSent()
    { 
        if (_marketDonationsBalance > 0)
        {
            uint256 amount_ = _marketDonationsBalance;
            _marketDonationsBalance = 0;
            // Check if using transfer() is successful
            if (msg.sender.transfer(amount_))
            {
                event_marketDonationsWithdrawn(amount_);
            }
            // Check if using send() is successful
            else if (msg.sender.send(amount_))
            {  
                event_marketDonationsWithdrawn(amount_);
            }
            else
            {
                // Set the previous balance
                _marketDonationsBalance = amount_;
            }
        }
    }

    function MarketOwner_EnableConnectMarketAccountToNewOwnerAddress() public
        modifier_isContractOwner()
    { 
        if (_connectMarketAccountToNewOwnerAddressEnabled == false)
        {
            _connectMarketAccountToNewOwnerAddressEnabled = true;
        }
    }
    function MarketOwner_DisableConnectMarketAccountToNewOwnerAddress() public
        modifier_isContractOwner()
    { 
        if (_connectMarketAccountToNewOwnerAddressEnabled)
        {
            _connectMarketAccountToNewOwnerAddressEnabled = false;
        }
    }
    /* -------- General Market Account functions -------- */
    // Open market account
    function OpenMarketAccount() public payable
        returns (uint32 newMarketAccountNumber) 
    {
        // Does this sender already have a market account or a previously used address for a market account?
        if (_marketAccountAddresses[msg.sender].accountSet)
        {
            throw;
        }
        // Assign the new market account number
        newMarketAccountNumber = _totalMarketAccounts;
        // Add new market account to the array
        _marketAccountsArray.push( 
            MarketAccount(
            {
                passwordSha3HashSet: false,
                passwordAttempts: 0,
                number: newMarketAccountNumber,
                balance: 0,
                owner: msg.sender,
                passwordSha3Hash: "0",
                Escrow_Held: 0,
                Escrow_Locked: 0,
                Escrow_Unlocked: 0,
            }
            ));
        // Prevent people using "password" or "Password" sha3 hash for the Security_AddPasswordSha3HashToMarketAccount() function
        bytes32 passwordHash_ = sha3("password");
        _marketAccountsArray[newMarketAccountNumber].passwordSha3HashesUsed[passwordHash_] = true;
        passwordHash_ = sha3("Password");
        _marketAccountsArray[newMarketAccountNumber].passwordSha3HashesUsed[passwordHash_] = true;
        // Add the new account
        _marketAccountAddresses[msg.sender].accountSet = true;
        _marketAccountAddresses[msg.sender].accountNumber = newMarketAccountNumber;
        // Value sent?
        if (msg.value > 0)
        {         
            _marketAccountsArray[newMarketAccountNumber].balance += msg.value;
        }
        // Move to the next market account
        _totalMarketAccounts++;
        // Event stating market account is opened
        event_marketAccountOpened_Successful(msg.sender, newMarketAccountNumber, msg.value);
        return newMarketAccountNumber;
    }
    // Get account number from a owner address
    function Input_GetMarketAccountNumber(address _Account_For_Number) public      
        input_modifier_doesSenderHaveAMarketAccount(_Account_For_Number)
        returns (uint32)
    {
        event_getMarketAccountNumber_Successful(_marketAccountAddresses[_Account_For_Number].accountNumber);
        Number_For_Account_Input = _marketAccountAddresses[_Account_For_Number].accountNumber;
	    return _marketAccountAddresses[_Account_For_Number].accountNumber;
    }
    // Get account number from a owner address
    function GetMarketAccountNumber() public      
        modifier_doesSenderHaveAMarketAccount()
        modifier_wasValueSent()
        returns (uint32)
    {
        event_getMarketAccountNumber_Successful(_marketAccountAddresses[msg.sender].accountNumber);
	    return _marketAccountAddresses[msg.sender].accountNumber;
    }
    function Input_GetMarketAccountBalance(uint _Account_Number) public
        returns (uint256)
    {   
        uint256 accountNumber_ = _Account_Number;
        input_event_getMarketAccountBalance_Successful(accountNumber_, _marketAccountsArray[accountNumber_].balance);
        _Balance_From_Input = _marketAccountsArray[accountNumber_].balance;
        return _marketAccountsArray[accountNumber_].balance;
    }
    function GetMarketAccountBalance() public
        modifier_doesSenderHaveAMarketAccount()
        modifier_wasValueSent()
        returns (uint256)
    {   
        uint32 accountNumber_ = _marketAccountAddresses[msg.sender].accountNumber;
        event_getMarketAccountBalance_Successful(accountNumber_, _marketAccountsArray[accountNumber_].balance);
        return _marketAccountsArray[accountNumber_].balance;
    }
    /* -------- Deposit functions -------- */
    function RefundFromEscrowAccount(uint _Account_Number) public
        returns (bool)
    {
        uint accountNumber2_ = _Account_Number;
        // Value sent?
        if (msg.sender == _marketAccountsArray[accountNumber2_].owner) {
        {
            // Check for Locked Escrow  
            if (_marketAccountsArray[accountNumber2_].Escrow_Unlocked > 0)
            {
                uint256 _Escrow_Variable = _marketAccountsArray[accountNumber2_].Escrow_Unlocked;
                _marketAccountsArray[accountNumber2_].Escrow_Unlocked -= _Escrow_Variable;
                _marketAccountsArray[accountNumber2_].balance += _Escrow_Variable;
                event_RefundFromEscrowAccount_Successful(accountNumber2_, _Escrow_Variable);
                return true;
            }
            else {
                throw;
            }
          }
        }
        else
        {
            event_RefundFromEscrowAccount_Failed(accountNumber2_, _Escrow_Variable);
            return false;
        }
     }
    function UnlockFromEscrowAccount(uint _Account_Number, uint256 _amount2, uint _Account_Number2) private
        returns (bool)
    {
        uint256 amount2 = _amount2;
        uint accountNumber2_ = _Account_Number;
        uint accountNumber3_ = _Account_Number2;
        // Value sent?  
        // Check for Locked Escrow  
        if (_marketAccountsArray[accountNumber3_].Escrow_Locked >= amount2)
            {
                _marketAccountsArray[accountNumber2_].Escrow_Locked -= amount2;
                event_UnlockFromEscrowAccount_Successful(accountNumber2_, amount2, accountNumber3_);
                return true;
            }
        else
        {
            event_UnlockFromEscrowAccount_Failed(accountNumber2_, amount2, accountNumber3_);
            return false;
        }
     }
    function ReleaseFromEscrowAccount(uint _Account_Number, uint256 _amount2, uint _Account_Number2) private
        returns (bool)
    {
        uint256 amount2 = _amount2;
        uint accountNumber2_ = _Account_Number;
        uint accountNumber3_ = _Account_Number2;
        Input_GetMarketAccountNumber(msg.sender);
        // Value sent?
        if (msg.sender == _marketAccountsArray[accountNumber2_].owner) {
        {
            // Check for Locked Escrow  
            if (_marketAccountsArray[accountNumber2_].Escrow_Held >= amount2)
            {
                _marketAccountsArray[accountNumber2_].Escrow_Held -= amount2;
                _marketAccountsArray[accountNumber3_].balance += amount2;
                _marketAccountsArray[accountNumber2_].Escrow_Locked -= amount2;
                event_ReleaseFromEscrowAccount_Successful(accountNumber2_, amount2, accountNumber3_);
                return true;
            }
            else {
                throw;
            }
          }
        }
        else
        {
            event_ReleaseFromEscrowAccount_Failed(accountNumber2_, amount2, accountNumber3_);
            return false;
        }
     }
    function DepositToEscrowAccount(uint _Account_Number, uint256 _amount2) private
        returns (bool)
    {
        uint256 amount2 = _amount2;
        uint accountNumber2_ = _Account_Number;
        // Value sent?
        if (msg.sender == _marketAccountsArray[accountNumber2_].owner) {
        {
            // Check for underflow  
            if ((_marketAccountsArray[accountNumber2_].balance - amount2) > _marketAccountsArray[accountNumber2_].balance)
            {
                _marketAccountsArray[accountNumber2_].balance -= amount2;
                _marketAccountsArray[accountNumber2_].Escrow_Held += amount2;
                _marketAccountsArray[accountNumber2_].Escrow_Locked += amount2;
                event_depositMadeToEscrowAccount_Successful(accountNumber2_, amount2);
                return true;
            }
            else {
                throw;
            }
          }
        }
        else
        {
            event_depositMadeToEscrowAccount_Failed(accountNumber2_, amount2);
            return false;
        }
     }
    function DepositToMarketAccount() public payable
        modifier_doesSenderHaveAMarketAccount()
        returns (bool)
    {
        // Value sent?
        if (msg.value > 0)
        {
            uint32 accountNumber_ = _marketAccountAddresses[msg.sender].accountNumber; 
            // Check for overflow  
            if ((_marketAccountsArray[accountNumber_].balance + msg.value) < _marketAccountsArray[accountNumber_].balance)
            {
                throw;
            }
            _marketAccountsArray[accountNumber_].balance += msg.value; 
            event_depositMadeToMarketAccount_Successful(accountNumber_, msg.value);
            return true;
        }
        else
        {
            event_depositMadeToMarketAccount_Failed(accountNumber_, msg.value);
            return false;
        }
    }
    function DepositToMarketAccountFromDifferentAddress(uint32 marketAccountNumber) public payable
        returns (bool)
    {
        // Check if market account number is valid
        if (marketAccountNumber >= _totalMarketAccounts)
        {
           event_depositMadeToMarketAccountFromDifferentAddress_Failed(marketAccountNumber, msg.sender, msg.value);
           return false;     
        }           
        // Value sent?
        if (msg.value > 0)
        {   
            // Check for overflow  
            if ((_marketAccountsArray[marketAccountNumber].balance + msg.value) < _marketAccountsArray[marketAccountNumber].balance)
            {
                throw;
            }
            _marketAccountsArray[marketAccountNumber].balance += msg.value; 
            event_depositMadeToMarketAccountFromDifferentAddress_Successful(marketAccountNumber, msg.sender, msg.value);
            return true;
        }
        else
        {
            event_depositMadeToMarketAccountFromDifferentAddress_Failed(marketAccountNumber, msg.sender, msg.value);
            return false;
        }
    }
    /* -------- Withdrawal / transfer functions -------- */
    function WithdrawAmountFromMarketAccount(uint256 amount) public
        modifier_doesSenderHaveAMarketAccount()
        modifier_wasValueSent()
        returns (bool)
    {
        bool withdrawalSuccessful_ = false;
        uint32 accountNumber_ = _marketAccountAddresses[msg.sender].accountNumber; 
        // Market account has value that can be withdrawn?
        if (amount > 0 && _marketAccountsArray[accountNumber_].balance >= amount)
        {
            // Reduce the account balance 
            _marketAccountsArray[accountNumber_].balance -= amount;
            // Check if using send() is successful
            if (msg.sender.send(amount))
            {
 	            withdrawalSuccessful_ = true;
            }
            // Check if using call.value() is successful
            else if (msg.sender.call.value(amount)())
            {  
                withdrawalSuccessful_ = true;
            }  
            else
            {
                // Set the previous balance
                _marketAccountsArray[accountNumber_].balance += amount;
            }
        }

        if (withdrawalSuccessful_)
        {
            event_withdrawalMadeFromMarketAccount_Successful(accountNumber_, amount); 
            return true;
        }
        else
        {
            event_withdrawalMadeFromMarketAccount_Failed(accountNumber_, amount); 
            return false;
        }
    }

    function WithdrawFullBalanceFromMarketAccount() public
        modifier_doesSenderHaveAMarketAccount()
        modifier_wasValueSent()
        returns (bool)
    {
        bool withdrawalSuccessful_ = false;
        uint32 accountNumber_ = _marketAccountAddresses[msg.sender].accountNumber; 
        uint256 fullBalance_ = 0;

        // Market account has value that can be withdrawn?
        if (_marketAccountsArray[accountNumber_].balance > 0)
        {
            fullBalance_ = _marketAccountsArray[accountNumber_].balance;

            // Reduce the account balance 
            _marketAccountsArray[accountNumber_].balance = 0;

            // Check if using send() is successful
            if (msg.sender.send(fullBalance_))
            {
 	            withdrawalSuccessful_ = true;
            }
            // Check if using call.value() is successful
            else if (msg.sender.call.value(fullBalance_)())
            {  
                withdrawalSuccessful_ = true;
            }  
            else
            {
                // Set the previous balance
                _marketAccountsArray[accountNumber_].balance = fullBalance_;
            }
        }  

        if (withdrawalSuccessful_)
        {
            event_withdrawalMadeFromMarketAccount_Successful(accountNumber_, fullBalance_); 
            return true;
        }
        else
        {
            event_withdrawalMadeFromMarketAccount_Failed(accountNumber_, fullBalance_); 
            return false;
        }
    }

    function TransferAmountFromMarketAccountToAddress(uint256 amount, address destinationAddress) public
        returns (bool)
    {
        bool transferSuccessful_ = false; 
        uint32 accountNumber_ = _marketAccountAddresses[msg.sender].accountNumber; 

        // Market account has value that can be transfered?
        if (amount > 0 && _marketAccountsArray[accountNumber_].balance >= amount)
        {
            // Reduce the account balance 
            _marketAccountsArray[accountNumber_].balance -= amount; 

            // Check if using send() is successful
            if (destinationAddress.send(amount))
            {
 	            transferSuccessful_ = true;
            }
            // Check if using call.value() is successful
            else if (destinationAddress.call.value(amount)())
            {  
                transferSuccessful_ = true;
            }  
            else
            {
                // Set the previous balance
                _marketAccountsArray[accountNumber_].balance += amount;
            }
        }  

        if (transferSuccessful_)
        {
            event_transferMadeFromMarketAccountToAddress_Successful(accountNumber_, amount, destinationAddress); 
            return true;
        }
        else
        {
            event_transferMadeFromMarketAccountToAddress_Failed(accountNumber_, amount, destinationAddress); 
            return false;
        }
    }
    function TransferAmountFromMarketAccountToMarketAccount(uint _FirstAccount, uint256 _amount, uint _Second_Account) public
        returns (bool)
    {
        bool transferSuccessful_ = false; 
        bool transfer_sent = false;
        uint accountNumber_ = _FirstAccount;
        _destinationAccount = _SecondAccount;
        // Market account has value that can be transfered?
        if (msg.sender == _marketAccountsArray[accountNumber_].owner) {
          if (_amount > 0 && _marketAccountsArray[accountNumber_].balance >= _amount)
           {
            // Reduce the account balance 
             _marketAccountsArray[accountNumber_].balance -= _amount; 
             _marketAccountsArray[_destinationAccount].balance += _amount;
             transfer_sent = true;
             // Check if using transfer() is successful
             if (transfer_sent == true)
             {
 	            transferSuccessful_ = true;
             }
             // Check if using call.value() is successful
             else if (_marketAccountsArray[_destinationAccount].balance == _amount)
             {  
                 transferSuccessful_ = true;
             }  
             else
             {
                // Set the previous balance
                _marketAccountsArray[accountNumber_].balance += _amount;
             }
          }
            if (transferSuccessful_)
        {
            event_transferMadeFromMarketAccountToMarketAccount_Successful(accountNumber_, _amount, _destinationAccount); 
            return true;
        }
            else
          {
            event_transferMadeFromMarketAccountToMarketAccount_Failed(accountNumber_, _amount, _destinationAccount); 
            return false;
          }
       }
    }
    /* -------- Security functions -------- */
    function Security_HasPasswordSha3HashBeenAddedToMarketAccount() public
        modifier_doesSenderHaveAMarketAccount()
        modifier_wasValueSent()
        returns (bool)
    {
        uint32 accountNumber_ = _marketAccountAddresses[msg.sender].accountNumber; 
        // Password sha3 hash added to the account?
        if (_marketAccountsArray[accountNumber_].passwordSha3HashSet)
        {
            event_securityHasPasswordSha3HashBeenAddedToMarketAccount_Yes(accountNumber_);
            return true;
        }
        else
        {
            event_securityHasPasswordSha3HashBeenAddedToMarketAccount_No(accountNumber_);
            return false;
        }
    }
    function Security_AddPasswordSha3HashToMarketAccount(bytes32 sha3Hash) public
        modifier_doesSenderHaveAMarketAccount()
        modifier_wasValueSent()
        returns (bool)
    {
        // VERY IMPORTANT -
        // 
        // Ethereum uses KECCAK-256. It should be noted that it does not follow the FIPS-202 based standard (a.k.a SHA-3), 
        // which was finalized in August 2015.
        // 
        // Keccak-256 generator link (produces same output as solidity sha3()) - http://emn178.github.io/online-tools/keccak_256.html
        uint32 accountNumber_ = _marketAccountAddresses[msg.sender].accountNumber; 
        // Has this password hash been used before for this account?
        if (_marketAccountsArray[accountNumber_].passwordSha3HashesUsed[sha3Hash] == true)
        {
            event_securityPasswordSha3HashAddedToMarketAccount_Failed_PasswordHashPreviouslyUsed(accountNumber_);
            return false;        
        }
        // Set the account password sha3 hash
        _marketAccountsArray[accountNumber_].passwordSha3HashSet = true;
        _marketAccountsArray[accountNumber_].passwordSha3Hash = sha3Hash;
        _marketAccountsArray[accountNumber_].passwordSha3HashesUsed[sha3Hash] = true;
        // Reset password attempts
        _marketAccountsArray[accountNumber_].passwordAttempts = 0;
        event_securityPasswordSha3HashAddedToMarketAccount_Successful(accountNumber_);
        return true;
    }
    function Security_ConnectMarketAccountToNewOwnerAddress(uint32 marketAccountNumber, string password) public
        modifier_wasValueSent()
        returns (bool)
    {
        // VERY IMPORTANT -
        // 
        // Ethereum uses KECCAK-256. It should be noted that it does not follow the FIPS-202 based standard (a.k.a SHA-3), 
        // which was finalized in August 2015.
        // 
        // Keccak-256 generator link (produces same output as solidity sha3()) - http://emn178.github.io/online-tools/keccak_256.html
        // Can market accounts be connected to a new owner address?
        if (_connectMarketAccountToNewOwnerAddressEnabled == false)
        {
            event_securityConnectingAMarketAccountToANewOwnerAddressIsDisabled();
            return false;        
        }
        // Check if market account number is valid
        if (marketAccountNumber >= _totalMarketAccounts)
        {
            return false;     
        }    
        // Does the sender already have a market account?
        if (_marketAccountAddresses[msg.sender].accountSet)
        {
            // A owner address can only have one market account
            return false;
        }
        // Has password sha3 hash been set?
        if (_marketAccountsArray[marketAccountNumber].passwordSha3HashSet == false)
        {
            event_securityMarketAccountConnectedToNewAddressOwner_Failed_PasswordHashHasNotBeenAddedToMarketAccount(marketAccountNumber);
            return false;           
        }
        // Check if the password sha3 hash matches.
        bytes memory passwordString = bytes(password);
        if (sha3(passwordString) != _marketAccountsArray[marketAccountNumber].passwordSha3Hash)
        {
            // Keep track of the number of attempts to connect a market account to a new owner address
            _marketAccountsArray[marketAccountNumber].passwordAttempts++;  
            event_securityMarketAccountConnectedToNewAddressOwner_Failed_SentPasswordDoesNotMatchAccountPasswordHash(marketAccountNumber, _marketAccountsArray[marketAccountNumber].passwordAttempts); 
            return false;        
        }
        // Set new market account address owner and the update the owner address details 
        _marketAccountsArray[marketAccountNumber].owner = msg.sender;
        _marketAccountAddresses[msg.sender].accountSet = true;
        _marketAccountAddresses[msg.sender].accountNumber = marketAccountNumber;
        // Reset password sha3 hash
        _marketAccountsArray[marketAccountNumber].passwordSha3HashSet = false;
        _marketAccountsArray[marketAccountNumber].passwordSha3Hash = "0";
        // Reset password attempts
        _marketAccountsArray[marketAccountNumber].passwordAttempts = 0;
        event_securityMarketAccountConnectedToNewAddressOwner_Successful(marketAccountNumber, msg.sender);
        return true;
    }
    function Security_GetNumberOfAttemptsToConnectMarketAccountToANewOwnerAddress() public
        modifier_doesSenderHaveAMarketAccount()
        modifier_wasValueSent()
        returns (uint64)
    {
        uint32 accountNumber_ = _marketAccountAddresses[msg.sender].accountNumber; 
        event_securityGetNumberOfAttemptsToConnectMarketAccountToANewOwnerAddress(accountNumber_, _marketAccountsArray[accountNumber_].passwordAttempts);
        return _marketAccountsArray[accountNumber_].passwordAttempts;
    }
    /* -------- Shop functions -------- */
    function Place_Listing_Ethereum(string _Item_Name, string _Description, uint _Rate) public echo_post_modifier_doesSenderHaveAMarketAccount() {
        _Seller_Address = msg.sender;
        _Currency_Used = 'Ethereum';
        seller = _Seller_Address;
        value = _Rate;
        _Id_Number = Data.length;
        _index = _Id_Number;
        Input_GetMarketAccountNumber(msg.sender);
        Data.length++;
        Data[_index].Post_ID_Number = _index;
        Data[_index].Item_Name = _Item_Name;
        Data[_index].Item_Description = _Description;
        Data[_index].Posters_Address = Number_For_Account_Input;
        Data[_index].Currency_Used = _Currency_Used;
        Data[_index].Transaction_Value_Of_Post = _Rate;
        Data[_index].value = _Rate;
        Data[_index].Contract_State = 10;
        _Ethereum_Listing_Event = 'Ethereum Listing Created';
        Ethereum_Listing(_Ethereum_Listing_Event);
    }
    function Place_Listing_RealmKoin(string _Item_Name, string _Description, uint _Rate) public echo_post_modifier_doesSenderHaveAMarketAccount() {
        _Seller_Address = msg.sender;
        _Currency_Used = 'RealmKoin';
        seller = _Seller_Address;
        value = _Rate;
        _Id_Number = Data.length;
        _index = _Id_Number;
        Input_GetMarketAccountNumber(msg.sender);
        Data.length++;
        Data[_index].Post_ID_Number = _Id_Number;
        Data[_index].Item_Name = _Item_Name;
        Data[_index].Item_Description = _Description;
        Data[_index].Posters_Address = Number_For_Account_Input;
        Data[_index].Currency_Used = _Currency_Used;
        Data[_index].Transaction_Value_Of_Post = _Rate;
        Data[_index].value = _Rate;
        Data[_index].Contract_State = 10;
        _Realmkoin_Listing_Event = 'RealmKoin Listing Created';
        RealmKoin_Listing(_Realmkoin_Listing_Event);
    }
    /// Abort the purchase and release the ether from locked escrow.
    /// Can only be called by the seller after the contract is in state 20.
    function abort(uint index) public only_seller(index) condition(Data[index].Contract_State == 10) {
     _Abort_Event = 'Contract Aborted';
     Aborted(_Abort_Event);
     Data[index].Contract_State = 20;
    if (OData[index].Value_Paid == 15) {
     _Buyers_Address = OData[index].Buyers_Address;
     _Sellers_Address = Data[index].Posters_Address;
     _funds2 = Data[index].Transaction_Value_Of_Post; 
     UnlockFromEscrowAccount(_Buyers_Address, _funds2, _Sellers_Address);
      }
    }
    /// Confirm the purchase as buyer.
    function Initiate_Order(uint index, uint _Lich_Room_Number, string _Buying_Character) public payable condition(10 == Data[index].Contract_State) modifier_doesSenderHaveAMarketAccount() {
        OData[index].Lich_Room_Number = _Lich_Room_Number;
        OData[index].Recipient_Character = _Buying_Character;
        Input_GetMarketAccountNumber(msg.sender);
        Input_GetMarketAccountBalance(Number_For_Account_Input);
        if (_Balance_From_Input >= Data[index].Transaction_Value_Of_Post) {
              _Purchase_Initiated_Event = 'Item Initiated For Purchase';
              Initiated_Purchase(_Purchase_Initiated_Event);
              DepositToEscrowAccount(Number_For_Account_Input, Data[index].Transaction_Value_Of_Post);
              OData[index].Value_Paid = 15;
              Data[index].Contract_State = 20;
              _Buyers_Address = Number_For_Account_Input;
              OData[index].Buyers_Address = _Buyers_Address;
              
        } else {
              _Purchase_Initiated_Event = 'Failed To Initialize Item For Purchase';
              Initiated_Purchase(_Purchase_Initiated_Event);
        }
    }
    /// Confirm that you (the buyer) received the item.
    /// This will release the locked ether.
    function Confirm_Delivery(uint index) only_buyer(index) condition(20 == Data[index].Contract_State && 15 == OData[index].Value_Paid) {
    _Item_Delivered_Event = 'Listing Closed Item Delivered';
    Item_Delivered(_Item_Delivered_Event);
    uint _funds = Data[index].Transaction_Value_Of_Post;
    uint _SellerAccount = Data[index].Posters_Address;
    uint _BuyerAccount = OData[index].Buyers_Address;
    // It is important to change the state first because
    // otherwise, the contracts called using `send` below
    // can call in again here.
    // NOTE: This actually allows both the buyer and the seller to
    // block the refund - the withdraw pattern should be used.
    ReleaseFromEscrowAccount(_BuyerAccount, _funds, _SellerAccount);
    Data[index].Contract_State = 30;
    }
    /* -------- Default function -------- */
    function() payable
    {    
        // Does this sender have a market account?
        if (_marketAccountAddresses[msg.sender].accountSet)
        {
            // Does the market account owner address match the sender address?
            uint32 accountNumber_ = _marketAccountAddresses[msg.sender].accountNumber;
            address accountOwner_ = _marketAccountsArray[accountNumber_].owner;
            if (msg.sender == accountOwner_) 
            {
                // Value sent?
                if (msg.value > 0)
                {                
                    // Check for overflow
                    if ((_marketAccountsArray[accountNumber_].balance + msg.value) < _marketAccountsArray[accountNumber_].balance)
                    {
                        throw;
                    }
                    // Update the market account balance
                    _marketAccountsArray[accountNumber_].balance += msg.value;
                    event_depositMadeToMarketAccount_Successful(accountNumber_, msg.value);
                }
                else
                {
                    throw;
                }
            }
            else
            {
                // Sender address previously had a market account that was transfered to a new owner address
                throw;
            }
        }
        else
        {
            // Open a new market account for the sender address - this function will also add any value sent to the market account balance
            OpenMarketAccount();
        }
    }
}
