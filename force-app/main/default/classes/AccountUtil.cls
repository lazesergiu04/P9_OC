/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 07-20-2020
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   07-17-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
public with sharing class AccountUtil {
    /**  Create list of Account that have Order records 
        if the Order.Status = Ordered calculate the turnover/ Annual revenue 
        by Sum of Order.TotalAmount
     **/

    public  void updateAccountAmount(Set<Id> accountsId, Map<Id,Decimal> amount) {
        List<Account> accToUpdate = [Select Id, AnnualRevenue From Account Where Id IN :accountsId];
        For(Account acc : accToUpdate){
            acc.AnnualRevenue += amount.get(acc.Id);
        }
        update(accToUpdate);
    }