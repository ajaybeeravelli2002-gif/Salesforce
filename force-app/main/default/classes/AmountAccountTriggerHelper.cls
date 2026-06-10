public with sharing class AmountAccountTriggerHelper {
    
    public void handleBeforeUpdate(Map<Id,Account> oldMap,Map<Id,Account>  newMap){
        List<Account> al= new List<Account>();
        for(Id om : oldMap.keySet()){
            Account na = newMap.get(om);
            if(na.AnnualRevenue==oldMap.get(om).AnnualRevenue){
                al.add(na);
            }
		}
        update al;
    }
}