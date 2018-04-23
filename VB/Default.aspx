<%@ Page Language="vb" AutoEventWireup="true" CodeFile="Default.aspx.vb" Inherits="_Default" %>

<%@ Register Assembly="DevExpress.Web.v14.1, Version=14.1.8.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web.ASPxCallbackPanel" TagPrefix="dx" %>

<%@ Register Assembly="DevExpress.Web.v14.1, Version=14.1.8.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a"
    Namespace="DevExpress.Web.ASPxGridView" TagPrefix="dx" %>
<%@ Register Assembly="DevExpress.Web.v14.1, Version=14.1.8.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a"
    Namespace="DevExpress.Web.ASPxEditors" TagPrefix="dx" %>
<%@ Register Assembly="DevExpress.Web.v14.1, Version=14.1.8.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web.ASPxPanel" TagPrefix="dx" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script type="text/javascript">
        var cellInfo;
        function Grid_BatchEditStartEditing(s, e) {
            var productNameColumn = s.GetColumnByField("C3");
            if (!e.rowValues.hasOwnProperty(productNameColumn.index))
                return;
            cellInfo = e.rowValues[productNameColumn.index];
            clbPanel.PerformCallback(e.visibleIndex);
        }

        function clbPanel_EndCallback(s, e) {
            C3memo.SetValue(cellInfo.value);
            C3memo.SetFocus();
        }
        function Grid_BatchEditEndEditing(s, e) {
            var productNameColumn = s.GetColumnByField("C3");
            if (!e.rowValues.hasOwnProperty(productNameColumn.index))
                return;
            var cellInfo = e.rowValues[productNameColumn.index];
            cellInfo.value = C3memo.GetValue();
            cellInfo.text = C3memo.GetText();
            C3memo.SetValue(null);
        }
        function Grid_BatchEditRowValidating(s, e) {
            var productNameColumn = s.GetColumnByField("C3");
            var cellValidationInfo = e.validationInfo[productNameColumn.index];
            if (!cellValidationInfo) return;
            var value = cellValidationInfo.value;
            if (!ASPxClientUtils.IsExists(value) || ASPxClientUtils.Trim(value) === "") {
                cellValidationInfo.isValid = false;
                cellValidationInfo.errorText = "C3 is required";
            }
        }

        var preventEndEditOnLostFocus = false;
        function C3memo_KeyDown(s, e) {
            var keyCode = ASPxClientUtils.GetKeyCode(e.htmlEvent);
            if (keyCode !== ASPxKey.Tab && keyCode !== ASPxKey.Enter) return;
            var moveActionName = e.htmlEvent.shiftKey ? "MoveFocusBackward" : "MoveFocusForward";
            if (grid.batchEditApi[moveActionName]()) {
                ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);
                preventEndEditOnLostFocus = true;
            }
        }
        function C3memo_LostFocus(s, e) {
            if (!preventEndEditOnLostFocus)
                grid.batchEditApi.EndEdit();
            preventEndEditOnLostFocus = false;
        }
    </script>

</head>
<body>
    <form id="frmMain" runat="server">
        <dx:ASPxGridView ID="Grid" runat="server" KeyFieldName="ID" OnBatchUpdate="Grid_BatchUpdate"
            OnRowInserting="Grid_RowInserting" OnRowUpdating="Grid_RowUpdating" OnRowDeleting="Grid_RowDeleting" ClientInstanceName="grid">
            <ClientSideEvents BatchEditStartEditing="Grid_BatchEditStartEditing" BatchEditEndEditing="Grid_BatchEditEndEditing"
                BatchEditRowValidating="Grid_BatchEditRowValidating" />
            <Columns>
                <dx:GridViewCommandColumn ShowNewButtonInHeader="true" ShowDeleteButton="true" />
                <dx:GridViewDataColumn FieldName="ID" >
                    <EditFormSettings Visible="False" />
                </dx:GridViewDataColumn>
                <dx:GridViewDataSpinEditColumn FieldName="C2" />
                <dx:GridViewDataColumn FieldName="C3" Width="100">
                    <EditItemTemplate>
                        <dx:ASPxCallbackPanel ID="clbPanel" runat="server" Width="100%" ClientInstanceName="clbPanel" OnCallback="clbPanel_Callback">
                            <ClientSideEvents EndCallback="clbPanel_EndCallback" />
                            <PanelCollection>
                                <dx:PanelContent ID="PanelContent1" runat="server">
                                    <dx:ASPxMemo ID="C3_memo" runat="server" ClientInstanceName="C3memo" Width="100%">
                                        <ClientSideEvents KeyDown="C3memo_KeyDown" LostFocus="C3memo_LostFocus" />
                                    </dx:ASPxMemo>
                                </dx:PanelContent>
                            </PanelCollection>
                        </dx:ASPxCallbackPanel>
                    </EditItemTemplate>
                </dx:GridViewDataColumn>
                <dx:GridViewDataCheckColumn FieldName="C4" />
                <dx:GridViewDataDateColumn FieldName="C5" />
            </Columns>
            <SettingsEditing Mode="Batch" />
        </dx:ASPxGridView>
    </form>
</body>
</html>