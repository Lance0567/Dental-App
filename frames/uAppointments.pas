unit uAppointments;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Layouts, System.Skia, FMX.Objects, FMX.Skia,
  FMX.ImgList, FMX.Calendar, FMX.Menus, System.Rtti, FMX.Grid.Style,
  FMX.ScrollBox, FMX.Grid, Data.Bind.EngExt, Fmx.Bind.DBEngExt, Fmx.Bind.Grid,
  System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.Components,
  Data.Bind.Grid, Data.Bind.DBScope, System.Threading,Data.DB, FireDAC.Stan.Param,
  FMX.Ani, FMX.MultiView, FMX.Edit, uToolbar;

type
  TfAppointments = class(TFrame)
    lytHeader: TLayout;
    lytTitle: TLayout;
    lbTitle: TLabel;
    lbDescription: TLabel;
    rCalendar: TRectangle;
    gAppointment: TGrid;
    bsdbAppointments: TBindSourceDB;
    blAppointments: TBindingsList;
    LinkGridToDataSourceBindSourceDB1: TLinkGridToDataSource;
    ScrollBox1: TScrollBox;
    lytComponents: TLayout;
    lytDateButtons: TLayout;
    lytButtonH: TLayout;
    btnAddNewAppointment: TCornerButton;
    cbDay: TCornerButton;
    cbWeek: TCornerButton;
    cbMonth: TCornerButton;
    fToolbar: TfToolbar;
    lytBottom: TLayout;
    procedure gAppointmentResized(Sender: TObject);
    procedure FrameResized(Sender: TObject);
    procedure btnAddNewAppointmentClick(Sender: TObject);
    procedure gAppointmentCellDblClick(const Column: TColumn;
      const Row: Integer);
    procedure FrameResize(Sender: TObject);
    procedure cbMonthClick(Sender: TObject);
  private
    { Private declarations }
  public
    procedure GridContentsResponsive;
    procedure GridContentsResponsive2;
    { Public declarations }
  end;

implementation

{$R *.fmx}

uses uDm, uMain;

{ Grid column resize }
procedure TfAppointments.GridContentsResponsive;
var
  i: Integer;
  NewWidth: Single;
  FixedWidth: Single;
  FixedColumns: Integer;
begin
  if gAppointment.ColumnCount = 0 then Exit;

  if frmMain.ClientWidth = 850 then
  begin
    // Fixed layout at 850px
    for i := 0 to gAppointment.ColumnCount - 1 do
    begin
      if (i = 1) or (i = 2) then
        gAppointment.Columns[i].Width := 230
      else
        gAppointment.Columns[i].Width := 170;
    end;
  end
  else if frmMain.ClientWidth > 850 then
  begin
    // Dynamic layout when wider than 850px
    FixedWidth := 250;      // width for 2nd and 3rd columns
    FixedColumns := 2;      // 2 fixed columns

    if gAppointment.ColumnCount > FixedColumns then
      NewWidth := (gAppointment.Width - (FixedWidth * FixedColumns)) / (gAppointment.ColumnCount - FixedColumns)
    else
      NewWidth := gAppointment.Width / gAppointment.ColumnCount;

    for i := 0 to gAppointment.ColumnCount - 1 do
    begin
      if (i = 1) or (i = 2) then
        gAppointment.Columns[i].Width := FixedWidth - 1
      else
        gAppointment.Columns[i].Width := NewWidth - 2;
    end;
  end;
end;

{ Grid column resize with 2ms delay }
procedure TfAppointments.GridContentsResponsive2;
begin
  TTask.Run(
    procedure
    begin
      Sleep(200); // wait 200ms

      TThread.Synchronize(nil,
        procedure
        var
          i: Integer;
          NewWidth: Single;
          FixedWidth: Single;
          FixedColumns: Integer;
        begin
          if gAppointment.ColumnCount = 0 then Exit;

          if frmMain.ClientWidth = 850 then
          begin
            // Fixed layout for 850px
            for i := 0 to gAppointment.ColumnCount - 1 do
            begin
              if (i = 1) or (i = 2) then
                gAppointment.Columns[i].Width := 230
              else
                gAppointment.Columns[i].Width := 170;
            end;
          end
          else if frmMain.ClientWidth > 850 then
          begin
            // Dynamic layout
            FixedWidth := 250; // Width for 2nd and 3rd columns
            FixedColumns := 2;

            if gAppointment.ColumnCount > FixedColumns then
              NewWidth := (gAppointment.Width - (FixedWidth * FixedColumns)) / (gAppointment.ColumnCount - FixedColumns)
            else
              NewWidth := gAppointment.Width / gAppointment.ColumnCount;

            for i := 0 to gAppointment.ColumnCount - 1 do
            begin
              if (i = 1) or (i = 2) then
                gAppointment.Columns[i].Width := FixedWidth - 1
              else
                gAppointment.Columns[i].Width := NewWidth - 2;
            end;
          end;
        end
      );
    end
  );
end;

{ Add new appointment }
procedure TfAppointments.btnAddNewAppointmentClick(Sender: TObject);
begin
  // Set record status to add
  frmMain.fAppointmentModal.RecordStatus := 'Add';

  // Set Modal Title
  frmMain.fAppointmentModal.lbTitle.Text := 'Create New Appointment';

  // Set Button Text
  frmMain.fAppointmentModal.btnCreateAppointment.Text := 'Create Appointment';

  // Reset tracking
  frmMain.fAppointmentModal.MemoTrackingReset := '';

  // Clear items
  frmMain.fAppointmentModal.ClearItems;

  // Hide validation components
  frmMain.fAppointmentModal.crPatient.Visible := False;
  frmMain.fAppointmentModal.crAppointmentTitle.Visible := False;

  // Show modal
  frmMain.fAppointmentModal.Visible := True;

  // Reset Scrollbox
  frmMain.fAppointmentModal.ScrollBox1.ViewportPosition := PointF(0,0);
end;

{ Edit Appointment }
procedure TfAppointments.gAppointmentCellDblClick(const Column: TColumn;
  const Row: Integer);
var
  cStatus: String;
begin
  // Set record status to edit
  frmMain.fAppointmentModal.RecordStatus := 'Edit';

  // Set Modal Title
  frmMain.fAppointmentModal.lbTitle.Text := 'Edit Existing Appointment';

  // Set Button Text
  frmMain.fAppointmentModal.btnCreateAppointment.Text := 'Update Appointment';

  // Reset tracking
  frmMain.fAppointmentModal.MemoTrackingReset := '';

  // Get Date from the database
  frmMain.fAppointmentModal.deDate.Date := dm.qAppointments.FieldByName('date').AsDateTime;
  frmMain.fAppointmentModal.lPickDate.Visible := False; // Hide Date pick label
  frmMain.fAppointmentModal.deDate.StyledSettings := [TStyledSetting.FontColor];  // Show date text

  // Get Status
  cStatus := dm.qAppointments.FieldByName('status').AsString;
  if cStatus = 'New' then
    frmMain.fAppointmentModal.cbStatus.ItemIndex := 0
  else if cStatus = 'Ongoing' then
    frmMain.fAppointmentModal.cbStatus.ItemIndex := 1
  else if cStatus = 'Completed' then
    frmMain.fAppointmentModal.cbStatus.ItemIndex := 2
  else if cStatus = 'Cancelled' then
    frmMain.fAppointmentModal.cbStatus.ItemIndex := 3;

  // Get Patient
  frmMain.fAppointmentModal.cbPatient.Enabled := False;
  frmMain.fAppointmentModal.cbPatient.Text := dm.qAppointments.FieldByName('patient').AsString;

  // Get Appointment Title
  frmMain.fAppointmentModal.eAppointmentTitle.Text := dm.qAppointments.FieldByName('appointment_title').AsString;

  // Get Start Time
  frmMain.fAppointmentModal.teStartTime.Text := dm.qAppointments.FieldByName('start_time').AsString;

  // Get End Time
  frmMain.fAppointmentModal.teEndTime.Text := dm.qAppointments.FieldByName('end_time').AsString;

  // Get Notes
  frmMain.fAppointmentModal.mNotes.Text := dm.qAppointments.FieldByName('notes').AsString;

  // Show Modal
  frmMain.fAppointmentModal.Visible := True;

  // Reset Scrollbox
  frmMain.fAppointmentModal.ScrollBox1.ViewportPosition := PointF(0, 0);
end;

{ Month Button }
procedure TfAppointments.cbMonthClick(Sender: TObject);
begin

end;

{ Frame Resize }
procedure TfAppointments.FrameResize(Sender: TObject);
begin
  GridContentsResponsive2;
end;

{ Frame Resized }
procedure TfAppointments.FrameResized(Sender: TObject);
begin
  GridContentsResponsive2;
end;

{ Grid Resized }
procedure TfAppointments.gAppointmentResized(Sender: TObject);
begin
  GridContentsResponsive2;
end;

end.
