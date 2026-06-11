import { LightningElement } from 'lwc';
    const COLUMNS=[
        {label:'Board Name',fieldName:'name'},
        {label:'Description',fieldName:'description'},
        {label:'sections',fieldName:'sections'},
        {type:'button',typeAttributes:{label:'View Board',name:'view_board'}}
    ];
export default class Boards extends LightningElement {
    columns = COLUMNS;
    handleAddBoard(event){

    }
}