public with sharing class BoardCreationHandler {
    @AuraEnabled
    public static void createSections(List<Section__c> Sections, String boardName){
       
        List<Board__c> boardList = [SELECT Id FROM Board__c WHERE Name =: boardName LIMIT 1];
        if(boardList.isEmpty()){
            throw new AuraHandledException('Board not found');
        }
        Id boardId = boardList[0].Id;
        for(Section__c section : Sections){
            section.Board__c = boardId;
        }
        try{
            insert Sections;
        }
        catch(DmlException e){
            throw new AuraHandledException('Error inserting sections: ' + e.getMessage());  
        }
        
    }
}   