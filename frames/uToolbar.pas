unit uToolbar;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  System.Skia, FMX.Controls.Presentation, FMX.Ani, FMX.Objects, FMX.Skia,
  FMX.ImgList, FMX.Layouts, FMX.MultiView;

type
  TfToolbar = class(TFrame)
    rToolbar: TRectangle;
    lBevel: TLine;
    lytToolbarH: TLayout;
    gIcon: TGlyph;
    lytUser: TLayout;
    slUserName: TSkLabel;
    rrUserImage: TRoundRect;
    rPopUp: TRectangle;
    FloatAnimation4: TFloatAnimation;
    lDate: TLabel;
    mvPopUp: TMultiView;
    cbAccountSettings: TCornerButton;
    cbLogout: TCornerButton;
    lDivider: TLine;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

end.
