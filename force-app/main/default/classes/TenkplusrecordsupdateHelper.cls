public with sharing class TenkplusrecordsupdateHelper {
    //List<Contact> contacts= new List<Contact>();
    //List<Account> accs = new List<Account>();
    public static void afterUpdate(Set<Account> newAccs){
        List<Account> accs =[select Phone from Account where Id in :newAccs ];
        List<Contact> contacts=[select Phone,AccountId from Contact where AccountId in :newAccs];
        Map<Id,List<Contact>> contactMap = new Map<Id,List<Contact>>();
        for(Contact c : contacts){
            if(contactMap.containsKey(c.AccountId)){
                contactMap.get(c.AccountId).add(c);
            }
        }
        List<Contact> cts= new List<Contact>();
        for(Account a : accs){
            for(Contact c: contactMap.get(a.Id)){
                Contact ct = new Contact(Id=c.Id, Phone= a.Phone);
                cts.add(ct);
            }
		}
        if(!cts.isEmpty()){
            update cts;
		}
     
    }
}