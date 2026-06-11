import { LightningElement } from 'lwc';
import BOARDOBJECTAPINAME from '@salesforce/resourceUrl/Board__c';
import NAME_FIELD from '@salesforce/schema/Board__c.Name';
import DESCRIPTION_FIELD from '@salesforce/schema/Board__c.Description__c';
import NO_OF_SECTIONS_FIELD from '@salesforce/schema/Board__c.NoOfSections__c';
const COLUMNS=[
        {label:'Board Name',fieldName:'name'},
        {label:'Description',fieldName:'description'},
        {label:'sections',fieldName:'sections'},
        {type:'button',typeAttributes:{label:'View Board',name:'view_board'}}
    ];
export default class Boards extends LightningElement {
    recordId;
    sections=[];
    boardObjectApiName = BOARDOBJECTAPINAME;
    boardNameField = NAME_FIELD;
    boardDescriptionField = DESCRIPTION_FIELD;
    boardNoOfSectionsField = NO_OF_SECTIONS_FIELD;
    columns = COLUMNS;
    showModalPopup = false;
    closePopupHandler(event){
        this.showModalPopup = false;
    }
    handleAddBoard(event){
        this.showModalPopup = true;
    }
    handleSectionChange(event){
        let noOfSections=event.target.value;
        this.sections=[];
        for(let i=0;i<noOfSections;i++){
            this.sections.push({id:i,label:'Section'+(i+1)+' title'});
        }
    }
}
