/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 07-16-2020
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   07-16-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/

/**Triger Handler should update the Account AnnualRevenue with the Order TotalAmount 
 * 
 * 
 */
public with sharing class OrderTriggerHandler {



	 public Set<Id> setAccountsIds = new set<Id>();
	 public Map<Id,Decimal> amount = new Map<Id,Decimal>();
	 public Map<Id,Decimal> accountIdWithAmountsToAdd = new Map<Id,Decimal>();
	 public Map<Id,Order> oldOrderMap = new Map<Id,Order>();
	public Map<Id,Order> newOrderMap = new Map<Id,Order>();

	public void afterUpdate(){
		
		updateAccountRevenue();
		updateAccountsFromOrder(oldOrder, newOrderMap)
	}


    public static void updateAccountRevenue() {
		List<Account> accountsToUpdate = [SELECT Id, AnnualRevenue FROM Account WHERE Id IN :setAccountsIds];
		for (Account currentAccount : accountsToUpdate) {
		        currentAccount.AnnualRevenue += amount.get(currentAccount.Id);
			}
		update(accountsToUpdate);
	}

	public static void updateAccountsFromOrder(){
		for(Order currentOrder : newOrderMap.values){
			if (currentOrder.Status =='Ordered' ) {
				
				Decimal previousAmount = accountIdWithAmountsToAdd.get(currentOrder.AccountId);
				accountIdWithAmountsToAdd.put(currentOrder.AccountId, previousAmount);

			}
		}update accountIdWithAmountsToAdd;
		 update setAccountsIds;
		
	}

	


}
