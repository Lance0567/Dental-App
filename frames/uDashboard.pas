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
  System.Threading,Data.DB;

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
    lbTodayAppointments: TLabel;
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
    fToolbar: TfToolbar;
    bsdbTodaysAppointment: TBindSourceDB;
    blTodaysAppointment: TBindingsList;
    LinkGridToDataSourceBindSourceDB1: TLinkGridToDataSource;
    procedure FrameResized(Sender: TObject);
    procedure btnNewPatientClick(Sender: TObject);
    procedure btnNewAppointmentClick(Sender: TObject);
    procedure gTodaysAppointmentResized(Sender: TObject);
    procedure FrameResize(Sender: TObject);
  private
    procedure GridContentsResponsive2;
    { Private declarations }
  public
    procedure GridContentsResponsive;
    procedure CardsResize;
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
        gTodaysAppointment.Columns[i].Width := 230
      else
        gTodaysAppointment.Columns[i].Width := 170;
    end;
  end
  else if frmMain.ClientWidth > 850 then
  begin
    // Dynamic layout when wider than 850px
    FixedWidth := 140;      // // Width for 1st and last columns
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
                gTodaysAppointment.Columns[i].Width := 230
              else
                gTodaysAppointment.Columns[i].Width := 170;
            end;
          end
          else if frmMain.ClientWidth > 850 then
          begin
            // Dynamic layout
            FixedWidth := 140; // Width for 1st and last columns
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
