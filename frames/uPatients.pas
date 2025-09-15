unit uPatients;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Layouts, System.Skia, FMX.Objects, FMX.Skia,
  FMX.ImgList, FMX.Edit, System.Rtti, FMX.Grid.Style, FMX.ScrollBox, FMX.Grid;

type
  TfPatients = class(TFrame)
    lytHeader: TLayout;
    lytTitle: TLayout;
    lbTitle: TLabel;
    lbDescription: TLabel;
    rToolbar: TRectangle;
    lytToolbarH: TLayout;
    lDate: TLabel;
    gIcon: TGlyph;
    lytUser: TLayout;
    slUserName: TSkLabel;
    rrUserImage: TRoundRect;
    lBevel: TLine;
    lytComponents: TLayout;
    eSearch: TEdit;
    lytSearch: TLayout;
    lytButtonH: TLayout;
    btnAddNewPatient: TCornerButton;
    lytBottom: TLayout;
    gPatients: TGrid;
    ScrollBox1: TScrollBox;
    rPatients: TRectangle;
    procedure gPatientsCellDblClick(const Column: TColumn; const Row: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

uses uPatientModal, uMain, uDashboard, uDm;


{ Double click record to Edit record }
procedure TfPatients.gPatientsCellDblClick(const Column: TColumn;
  const Row: Integer);
begin
  frmMain.fPatientModal.Visible := True;  // Show patient modal
  frmMain.fPatientModal.RecordStatus := 'Edit'; // Set record Status

  // Populate the modal form
  frmMain.fPatientModal.eFullName.Text := dm.qPatients.FieldByName('fullname').AsString;
end;

end.
