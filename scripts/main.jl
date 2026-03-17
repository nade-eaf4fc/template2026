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

	const FFT_PLANS = Dict{Int, Any}()

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

	resultsdir = joinpath(projdir, "results")
	mkpath(resultsdir)

	outdir = joinpath(resultsdir, "out_$(prefix)_$(datestr)")
	mkpath(outdir)

	@info "outdir = $outdir"
	@everywhere Random.seed!(0xC0FFEE + myid())

	df = DataFrame(a = [1], b = [2])

	ts = Dates.format(Dates.now(), "yyyymmdd_HHMMSS")
	path = joinpath(outdir, "sample_$(ts).csv")
	CSV.write(path, df)

	return nothing
end

main()
