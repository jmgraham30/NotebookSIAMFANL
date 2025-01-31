function plot_its_funs(plot_hist, caption; method=:nk, fpsize="12")
pstr=["k-","k-.","k--","k-o","k."]
subplot(1,2,1)
plot_res_vs_its(plot_hist, pstr, caption; fpsize=fpsize)
subplot(1,2,2)
plot_res_vs_fevals(plot_hist, pstr; method=method, fpsize=fpsize)
end

function plot_res_vs_fevals(plot_hist, pstr; method=:nk, fpsize="12")
xlab=("Function Evaluations")
if method == :nkj
xlab=("Jacobian-vector products")
end
ylab=("")
ip=1
resmax=0.0
for D4P in plot_hist
semilogy(D4P.fdata, D4P.relreshist, pstr[ip])
resmax=max(resmax,maximum(D4P.relreshist))
ip+=1
end
(xmin, xmax, ymin, ymax) = axis()
axis([0.0, xmax, ymin, max(1.0,resmax)])
itick=ceil(xmax/5.0)
xticks(0:itick:xmax)
xlabel(xlab, fontsize=fpsize)
ylabel(ylab, fontsize=fpsize)
end


function plot_res_vs_its(plot_hist, pstr, caption; fpsize="12")
xlab=("Iterations")
ylab=("Relative residual")
inlegend=Vector{String}()
ip=1;
resmax=0.0
for D4P in plot_hist
push!(inlegend,D4P.legend)
resmax=max(resmax,maximum(D4P.relreshist))
semilogy(D4P.itdata, D4P.relreshist, pstr[ip])
ip+=1
end
legend(inlegend)
xlabel(xlab, fontsize=fpsize)
ylabel(ylab, fontsize=fpsize)
(xmin, xmax, ymin, ymax) = axis()
itick=ceil(xmax/5.0)
xticks(0:itick:xmax)
axis([0.0, xmax, ymin, max(1.0,resmax)])
(caption == nothing) || title(caption, fontsize=fpsize)
end

function nl_stats!(plot_hist, nlout, legendstr; method=:nk)
fdata=nl_funcount(nlout; method=method)
xlen=length(nlout.history)
itdata=collect(0:1:xlen-1)
relreshist=nlout.history./nlout.history[1]
DT=Data_4_Plots(relreshist, itdata, fdata, legendstr)
push!(plot_hist,DT)
end

function nl_stats!(itdata, fdata, relreshist, nlout; method=:nk)
push!(fdata,nl_funcount(nlout; method=method))
xlen=length(nlout.history)
push!(itdata,collect(0:1:xlen-1))
push!(relreshist,nlout.history./nlout.history[1])
end

function nl_funcount(nout; method=:nk)
if method == :nk
fout=nout.stats.ifun+nout.stats.ijac+nout.stats.iarm
ftot=cumsum(fout)
elseif method == :nkj
fout=nout.stats.ijac
ftot=cumsum(fout)
else 
xlen=length(nout.history)
ftot = collect(1:1:xlen)
end
return ftot
end

