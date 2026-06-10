public class ContactAndLeadSearch {
    public static List<List<Sobject>> searchContactsAndLeads(String ln){
		List<List<Sobject>>  result= [find :ln in NAME FIELDS returning Lead,Contact];
        return result;
    }
}