import { LightningElement, track, api } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import loadOrderProducts from '@salesforce/apex/OrderStatusMgmtCtrl.loadOLs';
import rejectOrderItems from '@salesforce/apex/OrderStatusMgmtCtrl.rejectOLs';
import unrejectOrderItems from '@salesforce/apex/OrderStatusMgmtCtrl.unrejectOis';


export default class OrderStatusManagementDay extends LightningElement {
    // set recordId and init component, as current version of lwc which invoked by quick action can not directly get recordId via @api mark.
    _recordId;
    @api set recordId(value) {
        this._recordId = value;
        this.initComp();
    }
    // keep this function, it will be invoked while initiating the component.
    get recordId() {
        return this._recordId;
    }

    @track availableOiwList = [];
    @track rejectedOiwList = [];
    @track rejectReasonOpts = [];
    selectedALRows = [];
    selectedCLRows = [];
    columns = [];
    isLoading = true;
    isEmpty = true;
    isALEmpty = true;
    isCLEmpty = true;
    isShowReasonPicker = false;
    defaultRRVal = '';
    availableLinesTab = 'availableLines';
    rejectedLinesTab = 'rejectedLines';
    activeTab = 'availableLines';
    isALActived = true;
    label = {
        title: "Order Management",
        availableLines: "Available Lines",
        rejectedLines: "Rejected Lines",
        rejectProducts: "Reject Products",
        reactiveProducts: "Re-activate Products",
        update: "Update",
        reActive: "Re-activate",
        close: "Close",
        noRecord: "No record found",
        selOneItem: "Please select at least 1 item"
    }

    connectedCallback() {
        // this.initComp();
    }

    initComp() {
        this.selectedALRows = [];
        this.selectedCLRows = [];
        let datatableAL = this.template.querySelector('lightning-datatable[data-id="dtAL"]');
        let datatableCL = this.template.querySelector('lightning-datatable[data-id="dtCL"]');
        if(datatableAL){
            datatableAL.selectedRows = [];
        }
        if(datatableCL){
            datatableCL.selectedRows = [];
        }
        console.log("");
        loadOrderProducts({
            orderId: this._recordId
        })
        .then(result => {
            this.isEmpty = true;
            if(result.success) {
                this.availableOiwList = result.data.availableOiwList;
                this.rejectedOiwList = result.data.rejectedOiwList;
                this.columns = result.data.columns;
                this.rejectReasonOpts = result.data.rrOptions;
                this.isALEmpty = result.data.availableOiwList.length === 0;
                this.isCLEmpty = result.data.rejectedOiwList.length === 0;
                this.isEmpty = this.isALEmpty && this.isCLEmpty;
            } else {
                this.showMsg("error", "Error", result.msg);
                this.closeAction();
            }
        })
        .catch(error => {
            this.availableOiwList = [];
            this.rejectedOiwList = [];
            this.isEmpty = true;
            this.isALEmpty = true;
            this.isCLEmpty = true;
            this.showMsg("error", "Error", error.body.message);
        }).finally(() => {
            this.isLoading = false;
        });
    }

    handleTabActive(event){
        this.activeTab = event.target.value;
        this.isALActived = this.activeTab == this.availableLinesTab;
    }

    handleALRowSelection(event){
        this.selectedALRows = event.detail.selectedRows;
    }

    handleCLRowSelection(event){
        this.selectedCLRows = event.detail.selectedRows;
    }

    handleALSubmit() {
        console.log(JSON.stringify(this.selectedALRows));
        if(this.selectedALRows.length > 0) {
            this.isShowReasonPicker = true;
        } else {
            this.showMsg('error', 'Error', this.label.selOneItem);
        }
    }

    handleReasonClose() {
        this.isShowReasonPicker = false;
        this.defaultRRVal = '';
    }

    handleReasonSelected(e) {
        this.defaultRRVal = '';
        this.isShowReasonPicker = false;
        this.isLoading = true;
        rejectOrderItems({
            oiws: this.selectedALRows,
            rejectReason: e.detail.reason
        }).then(result => {
            if(result.success) {
                !!result.msg && this.showMsg("success", "Success", result.msg);
            } else {
                this.showMsg("error", "Error", result.msg);
            }
        })
        .catch(error => {
            this.showMsg("error", "Error", error.body.message);
        }).finally(() => {
            this.initComp();
        });
    }

    handleCLSubmit(e) {
        if(this.selectedCLRows.length === 0) {
            this.showMsg('error', 'Error', this.label.selOneItem);
            return;
        }
        this.isLoading = true;
        unrejectOrderItems({
            oiws: this.selectedCLRows
        }).then(result => {
            if(result.success) {
                !!result.msg && this.showMsg("success", "Success", result.msg);
            } else {
                this.showMsg("error", "Error", result.msg);
            }
        })
        .catch(error => {
            this.showMsg("error", "Error", error.body.message);
        }).finally(() => {
            this.initComp();
        });
    }
    
    showMsg(variant, title, msg){
        let mode = variant == 'success' ? "dismissible" : "sticky";
        const event = new ShowToastEvent({
            "variant": variant,
            "title": title,
            "message": msg,
            "mode": mode
        });
        this.dispatchEvent(event);
    }

    closeAction(){
        this.dispatchEvent(new CloseActionScreenEvent());
    }
}