unit uDashboard;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  System.Skia, System.Rtti, FMX.Grid.Style, FMX.Calendar, FMX.ScrollBox,
  FMX.Grid, FMX.Skia, FMX.ImgList, FMX.Controls.Presentation, FMX.Objects,
  FMX.Layouts, Math, FMX.Ani, FMX.Menus, FMX.ExtCtrls, FMX.MultiView, uToolbar,
  Data.Bind.EngExt, Fmx.Bind.DBEngExt, Fmx.Bind.Grid, System.Bindings.Outputs,
  Fmx.Bind.Editors, Data.Bind.Components, Data.Bind.Grid, Data.Bind.DBScope,
  System.Threading,Data.DB, FMX.Effects, FMX.ListBox, System.DateUtils,
  FireDAC.Stan.Param, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, FMX.ListView;

type
  TfDashboard = class(TFrame)
    ScrollBox1: TScrollBox;
    glytCards: TGridLayout;
    lytHeader: TLayout;
    lbTitle: TLabel;
    lbDescription: TLabel;
    lytTitle: TLayout;
    rCard1: TRectangle;
    lytCardD1: TLayout;
    lbTotalPatients: TLabel;
    lbTotalPatientsC: TLabel;
    rCard2: TRectangle;
    lytCardD2: TLayout;
    lbAppointments: TLabel;
    lbTodaysAppointmentC: TLabel;
    rCard3: TRectangle;
    lytCardD3: TLayout;
    lbNewAppointments: TLabel;
    lbNewAppointmentsC: TLabel;
    rCard4: TRectangle;
    lytCardD4: TLayout;
    lbCompleted: TLabel;
    lbCompletedC: TLabel;
    cIcon1: TCircle;
    gIcon1: TGlyph;
    cIcon2: TCircle;
    gIcon2: TGlyph;
    cIcon3: TCircle;
    gIcon3: TGlyph;
    cIcon4: TCircle;
    gIcon4: TGlyph;
    lytRecords: TLayout;
    rTodaysAppointment: TRectangle;
    gTodaysAppointment: TGrid;
    rQuickActions: TRectangle;
    lytTwoColumns: TLayout;
    btnNewPatient: TCornerButton;
    FloatAnimation1: TFloatAnimation;
    btnNewAppointment: TCornerButton;
    FloatAnimation2: TFloatAnimation;
    btnReportAnIssue: TCornerButton;
    FloatAnimation3: TFloatAnimation;
    lbQuickActions: TLabel;
    bsdbTodaysAppointment: TBindSourceDB;
    blTodaysAppointment: TBindingsList;
    LinkGridToDataSourceBindSourceDB1: TLinkGridToDataSource;
    rNoRecords: TRectangle;
    lNoRecords: TLabel;
    fToolbar: TfToolbar;
    ShadowEffect1: TShadowEffect;
    ShadowEffect2: TShadowEffect;
    ShadowEffect3: TShadowEffect;
    ShadowEffect4: TShadowEffect;
    ShadowEffect5: TShadowEffect;
    ShadowEffect6: TShadowEffect;
    lytTodaysAppointment: TLayout;
    lbTodayAppointments: TLabel;
    sbList: TSpeedButton;
    sbCalendar: TSpeedButton;
    cTodaysAppointment: TCalendar;
    procedure FrameResized(Sender: TObject);
    procedure btnNewPatientClick(Sender: TObject);
    procedure btnNewAppointmentClick(Sender: TObject);
    procedure gTodaysAppointmentResized(Sender: TObject);
    procedure FrameResize(Sender: TObject);
    procedure btnReportAnIssueClick(Sender: TObject);
    procedure sbCalendarClick(Sender: TObject);
    procedure sbListClick(Sender: TObject);
    procedure cTodaysAppointmentChange(Sender: TObject);
    procedure cTodaysAppointmentMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; var Handled: Boolean);
    procedure cTodaysAppointmentDateSelected(Sender: TObject);
    procedure cTodaysAppointmentDayClick(Sender: TObject);
  private
    procedure GridContentsResponsive2;
    procedure CleanListBox(AListBox: TListBox; AIndex: Integer);
    { Private declarations }
  public
    procedure PopulateList;
    procedure GridContentsResponsive;
    procedure CardsResize;
    procedure RefreshCalendarBadges;
    { Public declarations }
  end;

implementation

{$R *.fmx}

uses uDm, uMain;

{ Grid column resize }
procedure TfDashboard.GridContentsResponsive;
var
  i: Integer;
  NewWidth: Single;
  FixedWidth: Single;
  FixedColumns: Integer;
begin
  if gTodaysAppointment.ColumnCount = 0 then Exit;

  if frmMain.ClientWidth = 850 then
  begin
    // Fixed layout at 850px
    for i := 0 to gTodaysAppointment.ColumnCount - 1 do
    begin
      if (i = 1) or (i = 2) then
        gTodaysAppointment.Columns[i].Width := 110
      else
        gTodaysAppointment.Columns[i].Width := 180;
    end;
  end
  else if frmMain.ClientWidth > 850 then
  begin
    // Dynamic layout when wider than 850px
    FixedWidth := 110;      // // Width for 1st and last columns
    FixedColumns := 2;      // 2 fixed columns

    if gTodaysAppointment.ColumnCount > FixedColumns then
      NewWidth := (gTodaysAppointment.Width - (FixedWidth * FixedColumns)) / (gTodaysAppointment.ColumnCount - FixedColumns)
    else
      NewWidth := gTodaysAppointment.Width / gTodaysAppointment.ColumnCount;

    for i := 0 to gTodaysAppointment.ColumnCount - 1 do
    begin
      if (i = 0) or (i = gTodaysAppointment.ColumnCount - 1) then
        gTodaysAppointment.Columns[i].Width := FixedWidth - 1
      else
        gTodaysAppointment.Columns[i].Width := NewWidth - 2;
    end;
  end;
end;

{ Grid column resize with 2ms delay }
procedure TfDashboard.GridContentsResponsive2;
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
          if gTodaysAppointment.ColumnCount = 0 then Exit;

          if frmMain.ClientWidth = 850 then
          begin
            // Fixed layout for 850px
            for i := 0 to gTodaysAppointment.ColumnCount - 1 do
            begin
              if (i = 1) or (i = 2) then
                gTodaysAppointment.Columns[i].Width := 110
              else
                gTodaysAppointment.Columns[i].Width := 180;
            end;
          end
          else if frmMain.ClientWidth > 850 then
          begin
            // Dynamic layout
            FixedWidth := 110; // Width for 1st and last columns
            FixedColumns := 2;

            if gTodaysAppointment.ColumnCount > FixedColumns then
              NewWidth := (gTodaysAppointment.Width - (FixedWidth * FixedColumns)) / (gTodaysAppointment.ColumnCount - FixedColumns)
            else
              NewWidth := gTodaysAppointment.Width / gTodaysAppointment.ColumnCount;

            for i := 0 to gTodaysAppointment.ColumnCount - 1 do
            begin
              if (i = 0) or (i = gTodaysAppointment.ColumnCount - 1) then
                gTodaysAppointment.Columns[i].Width := FixedWidth - 1
              else
                gTodaysAppointment.Columns[i].Width := NewWidth - 2;
            end;
          end;
        end
      );
    end
  );
end;

{ Frame Resize }
procedure TfDashboard.FrameResize(Sender: TObject);
begin
  GridContentsResponsive2;
end;

{ Grid Resized }
procedure TfDashboard.gTodaysAppointmentResized(Sender: TObject);
begin
  GridContentsResponsive2;
end;

{ Calendar Notification badge }
procedure TfDashboard.CleanListBox(AListBox: TListBox; AIndex: Integer);
var
  Item: TListBoxItem;
begin
  Item := AListBox.ItemByIndex(AIndex);
  // Check if a badge exists in the TagObject
  if (Item.TagObject <> nil) and (Item.TagObject is TCircle) then
  begin
    // Remove the circle from the UI and free memory
    TCircle(Item.TagObject).Parent := nil;
    TCircle(Item.TagObject).Free;
    Item.TagObject := nil;
  end;
end;

{ List view populating }
procedure TfDashboard.PopulateList;
begin
  // 1. Refresh visual badges on the calendar
  RefreshCalendarBadges;

  // 2. Update the LiveBound query with the selected date
  dm.qDrawerAppointments.Close;
  dm.qDrawerAppointments.ParamByName('selected_date').AsString :=
    FormatDateTime('yyyy-mm-dd', cTodaysAppointment.Date);
  dm.qDrawerAppointments.Open;

  // 3. Toggle "No Records" components on the Main form drawer
  // Use frmMain to access the components inside the drawer
  frmMain.rNoRecords.Visible := dm.qDrawerAppointments.IsEmpty;
  frmMain.lNoRecords.Visible := dm.qDrawerAppointments.IsEmpty;

  // 4. Show the MultiView drawer
  frmMain.mvAppointments.ShowMaster;
end;

{ OnChange cTodaysAppointment }
procedure TfDashboard.cTodaysAppointmentChange(Sender: TObject);
begin
  TThread.ForceQueue(nil, procedure
  begin
    RefreshCalendarBadges;
  end);
end;

{ OnDateSelected cTodaysAppointment }
procedure TfDashboard.cTodaysAppointmentDateSelected(Sender: TObject);
begin
  PopulateList;
end;

{ OnDayClick cTodaysAppointment }
procedure TfDashboard.cTodaysAppointmentDayClick(Sender: TObject);
begin
  PopulateList;
end;

{ OnMouseWheel cTodaysAppointment }
procedure TfDashboard.cTodaysAppointmentMouseWheel(Sender: TObject;
  Shift: TShiftState; WheelDelta: Integer; var Handled: Boolean);
begin
  // Queue the refresh to ensure the UI has time to draw the Calendar first
  TThread.ForceQueue(nil, procedure
  begin
    RefreshCalendarBadges;
  end);
end;

{ Calendar Refresh Badges }
procedure TfDashboard.RefreshCalendarBadges;
var
  I: Integer;
  LB: TListBox;
  Circle: TCircle;
  BadgeText: TText;
  StartOfMonth, EndOfMonth, DayDate: TDateTime;
  DaysInMonth, StartMonthActive, EndMonthActive: Integer;
  DayValue: Integer;
  SearchDateStr: string;
  ItemWidth: Single;
begin
  cTodaysAppointment.ApplyStyleLookup;

  if (cTodaysAppointment.ControlsCount = 0) or
     (cTodaysAppointment.Controls[0].ControlsCount = 0) or
     (cTodaysAppointment.Controls[0].Controls[0].ControlsCount < 4) then
    Exit;

  try
    LB := TListBox(cTodaysAppointment.Controls.Items[0].Controls.Items[0].Controls.Items[3]);
  except
    Exit;
  end;

  StartOfMonth := EncodeDate(YearOf(cTodaysAppointment.DateTime), MonthOfTheYear(cTodaysAppointment.DateTime), 1);
  DaysInMonth := DaysInAMonth(YearOf(cTodaysAppointment.DateTime), MonthOfTheYear(cTodaysAppointment.DateTime));
  EndOfMonth := EncodeDate(YearOf(cTodaysAppointment.DateTime), MonthOfTheYear(cTodaysAppointment.DateTime), DaysInMonth);

  dm.qMonthAppointments.Close;
  dm.qMonthAppointments.ParamByName('start').AsString := FormatDateTime('yyyy-mm-dd', StartOfMonth);
  dm.qMonthAppointments.ParamByName('end').AsString := FormatDateTime('yyyy-mm-dd', EndOfMonth);
  dm.qMonthAppointments.Open;

  StartMonthActive := 0;
  EndMonthActive := 0;

  for I := 0 to LB.Count - 1 do
  begin
    CleanListBox(LB, I);

    if TryStrToInt(LB.ItemByIndex(I).Text, DayValue) then
    begin
      if DayValue = 1 then StartMonthActive := 1;

      if (StartMonthActive = 1) and (EndMonthActive = 0) then
      begin
        DayDate := EncodeDate(YearOf(cTodaysAppointment.DateTime), MonthOfTheYear(cTodaysAppointment.DateTime), DayValue);
        SearchDateStr := FormatDateTime('yyyy-mm-dd', DayDate);

        if dm.qMonthAppointments.Locate('app_date', SearchDateStr, []) then
        begin
          Circle := TCircle.Create(LB.ItemByIndex(I));
          Circle.Parent := LB.ItemByIndex(I);
          Circle.Fill.Color := TAlphaColorRec.Red;
          Circle.Stroke.Kind := TBrushKind.None;
          Circle.Size.Size := TSizeF.Create(16, 16);

          // --- POSITIONING FIX START ---
          ItemWidth := LB.ItemByIndex(I).Width;

          // If the item hasn't rendered yet, estimate its width based on the ListBox width
          if ItemWidth <= 0 then
            ItemWidth := LB.Width / 7;

          Circle.Position.X := ItemWidth - Circle.Width - 2;
          Circle.Position.Y := 2;

          // Use Anchors to pin the badge to the Top-Right regardless of layout changes
          Circle.Anchors := [TAnchorKind.akTop, TAnchorKind.akRight];
          // --- POSITIONING FIX END ---

          BadgeText := TText.Create(Circle);
          BadgeText.Parent := Circle;
          BadgeText.Align := TAlignLayout.Client;
          BadgeText.Text := dm.qMonthAppointments.FieldByName('total').AsString;
          BadgeText.TextSettings.FontColor := TAlphaColorRec.White;
          BadgeText.TextSettings.Font.Size := 9;
          BadgeText.TextSettings.Font.Style := [TFontStyle.fsBold];
          BadgeText.HitTest := False;

          LB.ItemByIndex(I).TagObject := Circle;
        end;

        if DayValue = DaysInMonth then EndMonthActive := 1;
      end;
    end;
  end;
end;

{ OnClick sbCalendar }
procedure TfDashboard.sbCalendarClick(Sender: TObject);
begin
  cTodaysAppointment.Visible := True;
  gTodaysAppointment.Visible := False;

  // Queue the refresh to ensure the UI has time to draw the Calendar first
  TThread.ForceQueue(nil, procedure
  begin
    RefreshCalendarBadges;
  end);

  frmMain.Dashboard;
end;

{ OnClick sbList }
procedure TfDashboard.sbListClick(Sender: TObject);
begin
  gTodaysAppointment.Visible := True;
  cTodaysAppointment.Visible := False;

  // Execute dashboard logic
  frmMain.Dashboard;
end;

{ Frame Resized }
procedure TfDashboard.FrameResized(Sender: TObject);
begin
  // Cards responsiveness
  CardsResize;

  // Grid Responsiveness
  GridContentsResponsive2;

  // Display Resolution
  if (frmMain.ClientWidth >= 1920) then
  begin
    // Cards
    glytCards.Height := 150;
    rCard2.Margins.Left := 10;
    rCard3.Margins.Left := 10;
    rCard4.Margins.Left := 10;

    // Records Padding
    lytRecords.Padding.Right := 30;

    // Quick Actions
    rQuickActions.Width := 340;

    // Button Text font size
    btnNewPatient.TextSettings.Font.Size := 14;
    btnNewAppointment.TextSettings.Font.Size := 14;
    btnReportAnIssue.TextSettings.Font.Size := 14;
  end
  else if (frmMain.ClientWidth >= 1600) then
  begin

  end
  else if (frmMain.ClientWidth >= 1366) then
  begin
    // Cards
    glytCards.Height := 150;
    rCard2.Margins.Left := 10;
    rCard3.Margins.Left := 10;
    rCard4.Margins.Left := 10;

    // Records Padding
    lytRecords.Padding.Right := 25;

    // Quick Actions
    rQuickActions.Width := 260;
  end
  else if (frmMain.ClientWidth >= 1050) then
  begin
    // Cards
    glytCards.Height := 140;

    // Records Padding
    lytRecords.Padding.Right := 30;
  end
  else if (frmMain.ClientWidth >= 850) OR (frmMain.ClientWidth <= 850) then
  begin
    // Cards
    glytCards.Height := 275;

    // Records Padding
    lytRecords.Padding.Right := 20;

    // Quick Actions
    rTodaysAppointment.Width := 280;
    rQuickActions.Width := 230;

    // Button Text font size
    btnNewPatient.TextSettings.Font.Size := 12;
    btnNewAppointment.TextSettings.Font.Size := 12;
    btnReportAnIssue.TextSettings.Font.Size := 12;
  end;
end;

{ Switch to Appointment tab }
procedure TfDashboard.btnNewAppointmentClick(Sender: TObject);
begin
  frmMain.sbAppointmentsClick(Sender);
end;

{ Switch to Patient tab }
procedure TfDashboard.btnNewPatientClick(Sender: TObject);
begin
  frmMain.sbPatientsClick(Sender);
end;

{ Report an Issue button }
procedure TfDashboard.btnReportAnIssueClick(Sender: TObject);
begin
  frmMain.fContactInfo.Visible := True;
end;

{ Card Resize }
procedure TfDashboard.CardsResize;
var
  AvailableWidth: Integer;
  ItemsPerRow: Integer;
begin
  AvailableWidth := Trunc(glytCards.Width);
  // Client Dimension condition
  if (frmMain.ClientWidth > 1900) AND not(frmMain.ClientWidth <= 1366) then
  begin
    ItemsPerRow := Max(1, AvailableWidth div 400);
    glytCards.ItemWidth := Trunc((AvailableWidth - (ItemsPerRow + 1) * 4) /
      ItemsPerRow);
  end
  else if (frmMain.ClientWidth >= 1366) AND not(frmMain.ClientWidth <= 850) then
  begin
    ItemsPerRow := Max(1, AvailableWidth div 225);
    glytCards.ItemWidth := Trunc((AvailableWidth - (ItemsPerRow + 1) * 4) /
      ItemsPerRow);
  end
  else if (frmMain.ClientWidth >= 850) OR (frmMain.ClientWidth <= 850) then
  begin
    ItemsPerRow := Max(1, AvailableWidth div 190);
    glytCards.ItemWidth := Trunc((AvailableWidth - (ItemsPerRow + 1) * 4) /
      ItemsPerRow);
  end;

  // Frame Dimension condition
  if (Self.Width > 1600) AND not(Self.Width <= 1270) then
  begin
    ItemsPerRow := Max(1, AvailableWidth div 400);
    glytCards.ItemWidth := Trunc((AvailableWidth - (ItemsPerRow + 1) * 4) /
      ItemsPerRow);
  end
  else if (Self.Width >= 1270) AND not(Self.Width <= 1076) then
  begin
    ItemsPerRow := Max(1, AvailableWidth div 310);
    glytCards.ItemWidth := Trunc((AvailableWidth - (ItemsPerRow + 1) * 4) /
      ItemsPerRow);
  end
  else if (Self.Width <= 1076) then
  begin
    ItemsPerRow := Max(1, AvailableWidth div 190);
    glytCards.ItemWidth := Trunc((AvailableWidth - (ItemsPerRow + 1) * 4) /
      ItemsPerRow);
  end;
end;

end.
