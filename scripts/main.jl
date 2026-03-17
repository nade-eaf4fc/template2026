using Distributed
const SCRIPTDIR = @__DIR__
const SRCDIR = normpath(joinpath(SCRIPTDIR, "..", "src"))
@everywhere begin
	using FFTW
	using DataFrames
	using Statistics
	using LinearAlgebra
	using CSV
	using Dates
	using Random
	using Base.Threads
	const FFT_PLANS = Dict{Int, FFTW.cFFTWPlan{ComplexF64}}()
	function get_fft_plan(N::Int)
		return get!(FFT_PLANS, N) do
			buf = Vector{ComplexF64}(undef, N)
			plan_fft!(buf, flags = FFTW.MEASURE)
		end
	end


end


function main()
	datestr = Dates.format(Dates.now(), "yyyymmdd_HHMMSS")
	prefix = "hogehoge"
	projdir = normpath(joinpath(@__DIR__, ".."))
	datadir = joinpath(projdir, "data")
	mkpath(datadir)
	outdir = joinpath(datadir, "out_$(datestr)_$(prefix)")
	mkpath(outdir)
	@info "outdir = $outdir"
	@everywhere Random.seed!(0xC0FFEE + myid())



	df = 1, 2
	ts = Dates.format(Dates.now(), "yyyymmdd_HHMMSS")
	path = joinpath(outdir, "ser_$(case_name)_fsf_$(st_fsf.fsf)_npay_$(npay)_iter_$(iter)_pid_$(myid())_$(ts).csv")
	CSV.write(path, df)
	return nothing
end

main()
