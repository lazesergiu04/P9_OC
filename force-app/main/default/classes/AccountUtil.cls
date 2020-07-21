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
    //method that takes as param a set of account id and the ammounts 
    //list of acconts that based on the accId and update the Annual Revenue

    public static void updateAccountAmount(Set<Id> accountsId, Map<Id,Decimal> amount) {
        List<Account> accToUpdate = [Select Id, AnnualRevenue From Account Where Id IN :accountsId];
        For(Account acc : accToUpdate){
            if(acc.AnnualRevenue != null){
             
            
            System.debug(acc.id + ' --acc id ');
           
            acc.AnnualRevenue += amount.get(acc.Id);
             System.debug(acc.AnnualRevenue + '---annual revenue');
        }
        update(accToUpdate);
       
    }
   
}
}