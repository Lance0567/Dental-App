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
  FMX.Ani, FMX.MultiView, FMX.Edit, System.DateUtils, uToolbar, FMX.Effects;

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
    Scrollbox1: TScrollBox;
    lytComponents: TLayout;
    lytDateButtons: TLayout;
    lytButtonH: TLayout;
    btnAddNewAppointment: TCornerButton;
    cbDay: TCornerButton;
    cbWeek: TCornerButton;
    cbMonth: TCornerButton;
    fToolbar: TfToolbar;
    lytBottom: TLayout;
    lNoRecords: TLabel;
    rNoRecords: TRectangle;
    ShadowEffect1: TShadowEffect;
    cbAllRecords: TCornerButton;
    procedure gAppointmentResized(Sender: TObject);
    procedure FrameResized(Sender: TObject);
    procedure btnAddNewAppointmentClick(Sender: TObject);
    procedure gAppointmentCellDblClick(const Column: TColumn;
      const Row: Integer);
    procedure FrameResize(Sender: TObject);
    procedure cbMonthClick(Sender: TObject);
    procedure cbDayClick(Sender: TObject);
    procedure cbWeekClick(Sender: TObject);
    procedure cbAllRecordsClick(Sender: TObject);
  private
    { Private declarations }
  public
    procedure GridContentsResponsive;
    procedure GridContentsResponsive2;
    procedure ButtonPressedResetter;
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
      if (i = 0) or (i = 4) or (i = 5) or (i = 6) then
        gAppointment.Columns[i].Width := 140
      else
        gAppointment.Columns[i].Width := 220;
    end;
  end
  else if frmMain.ClientWidth > 850 then
  begin
    // Dynamic layout when wider than 850px
    FixedWidth := 140;      // width for 1st, 5th, 6th columns
    FixedColumns := 4;      // 4 fixed columns

    if gAppointment.ColumnCount > FixedColumns then
      NewWidth := (gAppointment.Width - (FixedWidth * FixedColumns)) / (gAppointment.ColumnCount - FixedColumns)
    else
      NewWidth := gAppointment.Width / gAppointment.ColumnCount;

    for i := 0 to gAppointment.ColumnCount - 1 do
    begin
      if (i = 0) or (i = 4) or (i = 5) or (i = 6) then
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
              if (i = 0) or (i = 4) or (i = 5) or (i = 6) then
                gAppointment.Columns[i].Width := 140
              else
                gAppointment.Columns[i].Width := 220;
            end;
          end
          else if frmMain.ClientWidth > 850 then
          begin
            // Dynamic layout
            FixedWidth := 140; // Width for 1st, 5th and 6th columns
            FixedColumns := 4;

            if gAppointment.ColumnCount > FixedColumns then
              NewWidth := (gAppointment.Width - (FixedWidth * FixedColumns)) / (gAppointment.ColumnCount - FixedColumns)
            else
              NewWidth := gAppointment.Width / gAppointment.ColumnCount;

            for i := 0 to gAppointment.ColumnCount - 1 do
            begin
              if (i = 0) or (i = 4) or (i = 5) or (i = 6) then
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
  dm.RecordStatus := 'Add';

  // Set Modal Title
  frmMain.fAppointmentModal.lbTitle.Text := 'Create New Appointment';

  // Set Button Text
  frmMain.fAppointmentModal.btnCreateAppointment.Text := 'Create Appointment';

  // Set the Text of Pick date label
  frmMain.fAppointmentModal.lPickDate.Text := 'Pick a date';

  // Reset tracking
  frmMain.fAppointmentModal.MemoTrackingReset := '';

  // Clear items
  frmMain.fAppointmentModal.ClearItems;
  frmMain.fAppointmentModal.btnDelete.Visible := False;

  // Hide validation components
  frmMain.fAppointmentModal.crPatient.Visible := False;
  frmMain.fAppointmentModal.crAppointmentTitle.Visible := False;

  // Show modal
  frmMain.fAppointmentModal.Visible := True;

  // Form visibility
  frmMain.fAppointmentModal.FormVisibility;

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
  dm.RecordStatus := 'Edit';

  // Set Modal Title
  frmMain.fAppointmentModal.lbTitle.Text := 'Appointment Details';

  // Set Button Text
  frmMain.fAppointmentModal.btnCreateAppointment.Text := 'Update Appointment';

  // Reset tracking
  frmMain.fAppointmentModal.MemoTrackingReset := '';

  // Get Date from the database
  frmMain.fAppointmentModal.deDate.TodayDefault := False;
  frmMain.fAppointmentModal.deDate.Date := dm.qAppointments.FieldByName('date_appointment').AsDateTime;
  frmMain.fAppointmentModal.lPickDate.Text := FormatDateTime('mmm dd, yyyy', frmMain.fAppointmentModal.deDate.Date);  // Set date

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
 
{ Button Pressed Resetter }
procedure TfAppointments.ButtonPressedResetter;
begin
  cbDay.IsPressed := False;
  cbWeek.IsPressed := False;
  cbMonth.IsPressed := False;
  cbAllRecords.IsPressed := False;
end;

{ All Records }
procedure TfAppointments.cbAllRecordsClick(Sender: TObject);
begin
  if (dm.qAppointments.Active) then
    dm.qAppointments.Close;

  dm.qAppointments.SQL.Text :=
    'SELECT * ' +
    'FROM appointments';

  dm.qAppointments.Open;

  // Records checker for All appointment
  if dm.qAppointments.IsEmpty then
  begin
    lNoRecords.Visible := True;
    lNoRecords.Text := 'No records!';
    rNoRecords.Visible := True;
  end
  else
  begin
    lNoRecords.Visible :=  False;
    rNoRecords.Visible := False;
  end;

  // Grid responsive
  GridContentsResponsive;

  // Button Pressed reset
  ButtonPressedResetter;
  cbAllRecords.IsPressed := True;
end;

{ Day Button }
procedure TfAppointments.cbDayClick(Sender: TObject);
var
  todayStr: string;
begin
  todayStr := FormatDateTime('yyyy-mm-dd', Date); // Get date now

  if (dm.qAppointments.Active) then
    dm.qAppointments.Close;

  dm.qAppointments.SQL.Text :=
    'SELECT * ' +
    'FROM appointments ' +
    'WHERE (status IN (''New'', ''Ongoing'')) ' +
    '  AND (DATE(date_appointment) = :today)';  // Use a parameter for today's date

  dm.qAppointments.ParamByName('today').AsString := todayStr;
  dm.qAppointments.Open;

  // Records checker for todays appointment
  if dm.qAppointments.IsEmpty then
  begin
    lNoRecords.Visible := True;
    lNoRecords.Text := 'No Appointment for Today!';
    rNoRecords.Visible := True;
  end
  else
  begin
    lNoRecords.Visible :=  False;
    rNoRecords.Visible := False;
  end;

  // Grid responsive
  GridContentsResponsive;

  // Button Pressed reset
  ButtonPressedResetter;
  cbDay.IsPressed := True;
end;

{ Month Button }
procedure TfAppointments.cbMonthClick(Sender: TObject);
var
  startMonth, endMonth: TDateTime;
begin
  // Get the first and last date of current month
  startMonth := StartOfTheMonth(Date);
  endMonth := EndOfTheMonth(Date);

  if (dm.qAppointments.Active) then
    dm.qAppointments.Close;

  dm.qAppointments.SQL.Text :=
    'SELECT * ' +
    'FROM appointments ' +
    'WHERE (status IN (''New'', ''Ongoing'')) ' +
    '  AND (DATE(date_appointment) BETWEEN :startMonth AND :endMonth)';
  dm.qAppointments.ParamByName('startMonth').AsString := FormatDateTime('yyyy-mm-dd', startMonth);
  dm.qAppointments.ParamByName('endMonth').AsString := FormatDateTime('yyyy-mm-dd', endMonth);
  dm.qAppointments.Open;

  // Records checker for this month appointment
  if dm.qAppointments.IsEmpty then
  begin
    lNoRecords.Visible := True;
    lNoRecords.Text := 'No Appointment for this Month!';
    rNoRecords.Visible := True;
  end
  else
  begin
    lNoRecords.Visible :=  False;
    rNoRecords.Visible := False;
  end;

  // Grid responsive
  GridContentsResponsive;
  
  // Button Pressed reset
  ButtonPressedResetter;
  cbMonth.IsPressed := True;
end;

{ Week Button }
procedure TfAppointments.cbWeekClick(Sender: TObject);
var
  startWeek, endWeek: TDateTime;
begin
  // Calculate first and last day of current week (Sunday to Saturday)
  startWeek := StartOfTheWeek(Date); // Sunday
  endWeek := EndOfTheWeek(Date);     // Saturday

  if (dm.qAppointments.Active) then
    dm.qAppointments.Close;

  dm.qAppointments.SQL.Text :=
    'SELECT * ' +
    'FROM appointments ' +
    'WHERE (status IN (''New'', ''Ongoing'')) ' +
    '  AND (DATE(date_appointment) BETWEEN :startWeek AND :endWeek)';
  dm.qAppointments.ParamByName('startWeek').AsString := FormatDateTime('yyyy-mm-dd', startWeek);
  dm.qAppointments.ParamByName('endWeek').AsString := FormatDateTime('yyyy-mm-dd', endWeek);
  dm.qAppointments.Open;

  // Records checker for this month appointment
  if dm.qAppointments.IsEmpty then
  begin
    lNoRecords.Visible := True;
    lNoRecords.Text := 'No Appointment for this Week!';
    rNoRecords.Visible := True;
  end
  else
  begin
    lNoRecords.Visible :=  False;
    rNoRecords.Visible := False;
  end;

  // Grid responsive
  GridContentsResponsive;
  
  // Button Pressed reset
  ButtonPressedResetter;
  cbWeek.IsPressed := True;
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
