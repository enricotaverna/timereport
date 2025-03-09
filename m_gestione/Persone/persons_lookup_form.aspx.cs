﻿using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class persons_lookup_form : System.Web.UI.Page
{

    // recupera oggetto sessione
    public TRSession CurrentSession;

    protected void Page_Load(object sender, EventArgs e)
    {
        Auth.CheckPermission("MASTERDATA", "PERSONE");

        // recupera oggetto con variabili di sessione
        CurrentSession = (TRSession)Session["CurrentSession"];
        FVMode.Value = FVPersone.CurrentMode.ToString();

        if (!IsPostBack)
        {
            if (Request.QueryString["Persons_Id"] != null)
            {
                FVPersone.ChangeMode(FormViewMode.Edit);
                FVPersone.DefaultMode = FormViewMode.Edit;
            }

            // Populate DDLEmployeeNumber
            PopulateDDLEmployeeNumber();

        }
    }

    private void PopulateDDLEmployeeNumber()
    {
        DropDownList ddlEmployeeNumber = (DropDownList)FVPersone.FindControl("DDLEmployeeNumber");

        foreach (DataRow drRow in CurrentSession.dtPersonale.Rows)
        {
            ListItem liItem = new ListItem(drRow["EmployeeNumber"].ToString() + " " + drRow["Consulente"].ToString(), drRow["EmployeeNumber"].ToString());
            ddlEmployeeNumber.Items.Add(liItem);
        }
        ddlEmployeeNumber.DataTextField = "Consulente"; // Adjust this to the correct column name
        ddlEmployeeNumber.DataValueField = ""; // Adjust this to the correct column name
        ddlEmployeeNumber.DataBind();

        // Set the default value if in edit mode
        if (FVPersone.CurrentMode == FormViewMode.Edit)
        {
            object employeeNumber = DataBinder.Eval(FVPersone.DataItem, "EmployeeNumber");
            if (employeeNumber != null)
            {
                ddlEmployeeNumber.SelectedValue = employeeNumber.ToString().Trim();
            }
        }

    }

    protected void FVPersone_ModeChanging(object sender, FormViewModeEventArgs e)
    {
        FVMode.Value = e.NewMode.ToString();
        if (e.CancelingEdit)
            Response.Redirect("Persons_lookup_list.aspx");
    }

    protected void FVPersone_ItemInserted(object sender, FormViewInsertedEventArgs e)
    {
        Response.Redirect("Persons_lookup_list.aspx");
    }

    protected void FVPersone_ItemUpdated(object sender, FormViewUpdatedEventArgs e)
    {
        Response.Redirect("Persons_lookup_list.aspx");
    }

    protected void DSpersons_Insert(object sender, SqlDataSourceCommandEventArgs e)
    {
        DropDownList DDLEmployeeNumber = (DropDownList)FVPersone.FindControl("DDLEmployeeNumber");

        e.Command.Parameters["@CreatedBy"].Value = CurrentSession.UserId;
        e.Command.Parameters["@CreationDate"].Value = DateTime.Now;
        e.Command.Parameters["@EmployeeNumber"].Value = DDLEmployeeNumber.SelectedValue;
    }

    protected void DSpersons_Update(object sender, SqlDataSourceCommandEventArgs e)
    {
        DropDownList DDLEmployeeNumber = (DropDownList)FVPersone.FindControl("DDLEmployeeNumber");

        e.Command.Parameters["@LastModifiedBy"].Value = CurrentSession.UserId;
        e.Command.Parameters["@LastModificationDate"].Value = DateTime.Now;
        e.Command.Parameters["@EmployeeNumber"].Value = DDLEmployeeNumber.SelectedValue;
    }

    protected void DDLManager_DataBound(object sender, EventArgs e)
    {
        DropDownList ddlManager = (DropDownList)sender;
        object managerId = DataBinder.Eval(FVPersone.DataItem, "Manager_id");
        string selectedValue = managerId != null ? managerId.ToString() : "";

        // Check if the selected value exists in the list
        ddlManager.SelectedValue = ddlManager.Items.FindByValue(selectedValue) != null ? selectedValue : "";
    }
}