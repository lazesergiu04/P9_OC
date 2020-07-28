/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 07-28-2020
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   07-28-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
@isTest
public class OrderTrigger_Test {
    @testSetup
	static void testSetup() {
		// Insert of 1 product
		Product2 product1 = new Product2(Name = 'Laptop', Family = 'Computers');
		insert product1;
        
		// Insert of PricebookEntry
		PricebookEntry priceBook = new PricebookEntry(
            								//Explain this line 
											Pricebook2Id = Test.getStandardPricebookId(),
											Product2Id = product1.Id,
											UnitPrice = 200,
											IsActive = true);
		Insert priceBook;
        
		// Insert of 2 accounts
		Account testAccountNoRevenue = new Account(Name = 'TestAcc');
		Account testAccountWithRevenue = new Account(Name = 'TestAccRev', AnnualRevenue = 1000);
		insert new Account[]{testAccountNoRevenue, testAccountWithRevenue};
            
		// Insert of 2 contracts, one for each account
		Contract ctr1 = new Contract(	AccountId = testAccountNoRevenue.Id,
										ContractTerm = 8,
										StartDate = date.today(),
										Status = 'Draft');
		Contract ctr2 = new Contract(	AccountId = testAccountWithRevenue.Id,
										ContractTerm = 10,
										StartDate = date.today(),
										Status = 'Draft');
		insert new Contract[]{ctr1, ctr2};
            
		// Then activate contracts
		ctr1.Status = 'Activated';
		ctr2.Status = 'Activated';
		update ctr1;
		update ctr2;
	}
    //Test if the AnnualRevenue is updated when the Account.AnnualRevenue = 0;
    @isTest
	static void updateAccountRevenue_WhenAccountHasInitialValueZero(){
		Account ac = [SELECT Id, AnnualRevenue FROM Account WHERE Name = 'TestAcc'];
        ac.AnnualRevenue = 0;
        update ac;
        
		PricebookEntry pbe = [SELECT Id, Pricebook2Id FROM PricebookEntry WHERE UnitPrice = 200];
		//System.assertEquals(0, ac.AnnualRevenue,'The revenue should be 0');
		Test.startTest();
		// Insert Order with quantity of 1 and Value of 200 
		Order o1 = new Order(AccountId = ac.Id, Status = 'Draft', Pricebook2Id = pbe.Pricebook2Id, EffectiveDate = date.today());
		insert o1;
		// Insert of 1 orderItem to the Order
		OrderItem oi1 = new OrderItem(OrderId = o1.Id, PricebookEntryId = pbe.Id, Quantity=1, UnitPrice = 200);
		insert oi1;
		o1.Status = 'Ordered';
		update o1; // Generates an update for the trigger to be launched
		Test.stopTest();
		Account acAfterUpdate = [SELECT Id,AnnualRevenue FROM Account WHERE Name = 'TestAcc'];
      
		System.assertEquals(200, acAfterUpdate.AnnualRevenue,'The revenue should be 200');
	}
    
    // Test if AnnualRevenue is updating when Account.AnnualRevenue = 1000
    @isTest
	static void updateAccountRevenue_WhenAccountsHasInitialValueOneThousand(){
		Account ac = [SELECT Id, AnnualRevenue FROM Account WHERE Name = 'TestAccRev'];
		PricebookEntry pbe = [SELECT Id, Pricebook2Id FROM PricebookEntry WHERE UnitPrice = 200];
		System.assertEquals(1000, ac.AnnualRevenue,'The revenu should be Null');
		Test.startTest();
		// Insert of 1 order of price 200
		Order o1 = new Order(AccountId = ac.Id, Status = 'Draft', Pricebook2Id = pbe.Pricebook2Id, EffectiveDate = date.today());
		insert o1;
		// Insert of 1 item to the order
		OrderItem oi1 = new OrderItem(OrderId = o1.Id, PricebookEntryId = pbe.Id, Quantity=1, UnitPrice = 200);
		insert oi1;
		o1.Status = 'Ordered';
		update o1; // Generates an update for the trigger to be launched
		Test.stopTest();
		Account acAfterUpdate = [SELECT Id, AnnualRevenue FROM Account WHERE Name = 'TestAccRev'];
		System.assertEquals(1200, acAfterUpdate.AnnualRevenue,'The revenu should be 1200');
	}
    
    //Test if NetAmount is updated based in Shipment Cost and Total amount of the Order
    @isTest
	static void updateNetAmount_WhenShipmentCostIsProvided_BasedOnTotalAmount(){
		Account acc = [SELECT Id, AnnualRevenue FROM Account WHERE Name = 'TestAcc'];
		PricebookEntry pbe = [SELECT Id, Pricebook2Id FROM PricebookEntry WHERE UnitPrice =200];
		Test.startTest();
		// Insert of 1 order of price 550 and Shipment cost of 100€
		Order o1 = new Order(AccountId = acc.Id, Status = 'Draft', Shipment_Cost__c = 100, Pricebook2Id = pbe.Pricebook2Id, EffectiveDate = date.today());
		insert o1;
		// Insert of 1 item to the order
		OrderItem oi1 = new OrderItem(OrderId = o1.Id, PricebookEntryId = pbe.Id, Quantity=1, UnitPrice = 200);
		insert oi1;
		o1.Status = 'Ordered';
		update o1; // Generates an update for the trigger to be launched
		Test.stopTest();
		Account acAfterUpdate = [SELECT Id FROM Account WHERE Name = 'TestAcc'];
		Order o1AfterUpdate = [SELECT Id, NetAmount__c FROM Order WHERE AccountId = :acAfterUpdate.Id];
		System.assertEquals(100, o1AfterUpdate.NetAmount__c,'The net amount of order should be 100');
	}
    
    

}