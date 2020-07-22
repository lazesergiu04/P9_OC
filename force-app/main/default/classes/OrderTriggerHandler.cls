/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 07-20-2020
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   07-16-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/

/**Triger Handler uses the Account Util class to update the account Annual Revenue
 * Update the accounts based on Trigger.NewMap and Trigger.OldMap, <Id,Order> 
 * When the Status= Ordered, updates the amount
 * 
 * 
 */
public with sharing class OrderTriggerHandler {

	public Set<Id> setAccountsIds = new set<Id>();
	 public Map<Id,Decimal> amount = new Map<Id,Decimal>();
	 public Map<Id,Decimal> accountIdWithAmountsToAdd = new Map<Id,Decimal>();
	 public AccountUtil au = new AccountUtil();

	public  void updateAccountsFromOrder(Map<Id,Order> orderOldMap, Map<Id,Order> orderNewMap){
        
		for(Order currentOrder : orderNewMap.values()){
          
                if (orderOldMap.get(currentOrder.Id).Status != currentOrder.Status && currentOrder.Status == 'Ordered')  {
					//If there is an existing order add the amount to the order
					
					accountIdWithAmountsToAdd.put(currentOrder.AccountId, currentOrder.TotalAmount);
				
                    setAccountsIds.add(currentOrder.AccountId);
                   
                    System.debug(accountIdWithAmountsToAdd + ' --- acc to add afer put()');

			}else {
				//if there isn't an existing order for this Account, add a new Map<Id,Order>
				 accountIdWithAmountsToAdd.put(currentOrder.AccountId, currentOrder.TotalAmount);
                
				 setAccountsIds.add(currentOrder.AccountId);
			}
			}	AccountUtil.updateAccountAmount(setAccountsIds,accountIdWithAmountsToAdd);
			
        	System.debug(accountIdWithAmountsToAdd + ' -- acc id with amount at AccountUtil');
	}
}