import { LightningElement } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import loadData from "@salesforce/apex/FileUploadController.loadData";

export default class FileUpload extends LightningElement {
  error;
  isLoaded = false;

  get acceptedFormats() {
    return [".csv"];
  }

  uploadFileHandler(event) {
    this.isLoaded = true;
    const uploadedFiles = event.detail.files;

    loadData({ contentDocumentId: uploadedFiles[0].documentId })
      .then((result) => {
        this.isLoaded = false;
        window.console.log("result ===> " + result);
        this.strMessage = result;
        this.dispatchEvent(
          new ShowToastEvent({
            title: "Success",
            message: result,
            variant: result.includes("success") ? "success" : "error",
            mode: "sticky"
          })
        );
      })
      .catch((error) => {
        window.console.log("error ===> " + JSON.stringify(error));
        this.isLoaded = false;
        this.error = error;
        this.dispatchEvent(
          new ShowToastEvent({
            title: "Error!!",
            message: JSON.stringify(error),
            variant: "error",
            mode: "sticky"
          })
        );
      });
  }
}