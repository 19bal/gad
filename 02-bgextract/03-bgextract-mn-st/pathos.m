function po = pathos(p)
% function po = pathos(p)
% 
% isletim sistemine (OS) gore path sep i gunceller
%
% girdi: `p` degiskeni linux turunde
% cikti: `po` degiskeni OS turunde
%
% ornek
%	p = '../foo/bar.m';
%	po = pathos(p)
%	% lin: po = p
%   % win: po = '..\\foo\\bar.m'
%
% ayni zamanda bk: pathsep
po = p;

if pathsep == '\'
	ps = '\\';
	po = strrep(p, '/', ps);
end
