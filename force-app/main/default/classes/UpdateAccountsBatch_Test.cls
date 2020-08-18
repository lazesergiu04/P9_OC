/**
 * @description       : 
 * @author            : Sergiu Laze
 * @group             : 
 * @last modified on  : 18-08-2020
 * @last modified by  : Sergiu Laze
 * Modifications Log 
 * Ver   Date         Author        Modification
 * 1.0   18-08-2020   Sergiu Laze   Initial Version
**/
@isTest
public class UpdateAccountsBatch_Test {
    @testSetup
	static void testSetup() {
		// Insert of 1 product
		Product2 product1 = new Product2(Name = 'Laptop', Family = 'Computers');
		insert product1;
		// Insert of PricebookEntry
		PricebookEntry pbe = new PricebookEntry(
			Pricebook2Id = Test.getStandardPricebookId(),
			Product2Id = product1.Id,
			UnitPrice = 10,
			IsActive = true
		);
		Insert pbe;
		// Insert of 2 accounts
		Account accountOneOrder = new Account(Name = 'AccOneOrder');
		Account accountMultipleOrders = new Account(Name = 'AccMultipleOrders');
		insert new Account[]{accountOneOrder, accountMultipleOrders};

		// Insert of 1 contract, one for each account
		Contract ctr1 = new Contract(	AccountId = accountOneOrder.Id,
										ContractTerm = 4,
										StartDate = date.today(),
										Status = 'Draft');
		Contract ctr2 = new Contract(	AccountId = accountMultipleOrders.Id,
										ContractTerm = 3,
										StartDate = date.today(),
										Status = 'Draft');
		insert new Contract[]{ctr1, ctr2};
		// Then activate contracts
		ctr1.Status = 'Activated';
		ctr2.Status = 'Activated';
		update ctr1;
		update ctr2;

		// Insert of 1 order of price 12 to accountWith1order
		Order o1 = new Order(AccountId = accountOneOrder.Id, Status = 'Draft', Pricebook2Id = pbe.Pricebook2Id, EffectiveDate = date.today());
		insert o1;
		// Insert of 1 item to the order
		OrderItem oi1 = new OrderItem(OrderId = o1.Id, PricebookEntryId = pbe.Id, Quantity=1, UnitPrice = 10);
		insert oi1;
		o1.Status = 'Ordered';
		update(o1);

		// Insert of 100 orders 
		Order[] orderList = new Order[]{};
		for (Integer i=0; i<100; i++) {
			Order orderForList = new Order(AccountId = accountMultipleOrders.Id, Status = 'Draft', Pricebook2Id = pbe.Pricebook2Id, EffectiveDate = date.today());
			orderList.add(orderForList);
		}
		insert orderList;

		// Insert of orderItems
		OrderItem[] orderItemList = new OrderItem[]{};
		for (Order orderIteration : orderList) {
			orderItem orderItemForList = new OrderItem(OrderId = orderIteration.Id, PricebookEntryId = pbe.Id, Quantity=1, UnitPrice = 10);
			orderItemList.add(orderItemForList);
			orderIteration.Status = 'Ordered';
		}
		insert orderItemList;
		update(orderList);

		// Set the AnnualRevenue to 0
		accountOneOrder.AnnualRevenue = 0;
		update(accountOneOrder);
		accountMultipleOrders.AnnualRevenue = 0;
		update(accountMultipleOrders);
	}
    
    //Test if AnnualRevenue is updateing using batch with an account with one order
    @isTest
	static void updateAccountRevenue_withAccountOneOrder(){
		Test.startTest();
		UpdateAccountsAR_Batch updateAccountsB = new UpdateAccountsAR_Batch();
		Database.executeBatch(updateAccountsB);
		Test.stopTest();
		Account accAfterUpdate = [SELECT Id, AnnualRevenue FROM Account WHERE Name = 'AccOneOrder'];
		System.assertEquals(10, accAfterUpdate.AnnualRevenue,'The revenu should be 10');
	}
    
    @isTest
	static void updateAccountRevenue_withAccountMultipleOrders(){
		Test.startTest();
		UpdateAccountsAR_Batch updateAccountsB = new UpdateAccountsAR_Batch();
		Database.executeBatch(updateAccountsB);
		Test.stopTest();
		Account accAfterUpdate = [SELECT Id, AnnualRevenue FROM Account WHERE Name = 'AccMultipleOrders'];
		System.assertEquals(1000, accAfterUpdate.AnnualRevenue,'The revenu should be 1000');
	}
    
    

}