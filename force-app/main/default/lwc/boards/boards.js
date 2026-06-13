import { LightningElement,track,wire } from 'lwc';
import { createSections } from '@salesforce/apex/BoardCreationHandler.createSections';   
import BOARDOBJECTAPINAME from '@salesforce/schema/Board__c';
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
    @track sections = [];
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
        let flag = event.target.value>0?true:false;
        console.log('flag-->',flag);
        if(!flag){return;}
        let noOfSections=event.target.value;
        let temp=[];
        for(let i=0;i<noOfSections;i++){
            temp.push({id:i,label:`Section${i+1} Title`});
        }
        this.sections = temp;
    }
    handleSuccessBoard(event){ 
            const customFields= this.template.querySelectorAll('lightning-record-edit-form.lightning-input');
            let boardNameField=this.template.querySelector('lightning-input-field[id="boardName"]');
            customFields.forEach(field =>{
                let newSection={
                    Name:field.value,
                    Board:boardNameField.value
                }
                this.sections.push(newSection);
            })
    }
    createSectionCallout(){
        createSections({Sections:this.sections,board__c:this.boardNameField})
        .then((result)=>{
            console.log('result--->',result);
        })
        .catch((error) =>{
            console.error('error-->',error);
        })
    }
    
}
