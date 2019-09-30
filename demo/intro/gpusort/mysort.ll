; ModuleID = 'mysort.cpp'
source_filename = "mysort.cpp"
target datalayout = "e-m:o-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx10.12.0"

%struct.__sFILE = type { i8*, i32, i32, i16, i16, %struct.__sbuf, i32, i8*, i32 (i8*)*, i32 (i8*, i8*, i32)*, i64 (i8*, i64, i32)*, i32 (i8*, i8*, i32)*, %struct.__sbuf, %struct.__sFILEX*, i32, [3 x i8], [1 x i8], %struct.__sbuf, i32, i64 }
%struct.__sFILEX = type opaque
%struct.__sbuf = type { i8*, i32 }
%struct.timeval = type { i64, i32 }

@__stderrp = external global %struct.__sFILE*, align 8
@.str = private unnamed_addr constant [46 x i8] c"Usage: %s input_file number_of_elements mode\0A\00", align 1
@.str.1 = private unnamed_addr constant [3 x i8] c"rb\00", align 1
@.str.2 = private unnamed_addr constant [16 x i8] c"Cannot open %s\0A\00", align 1
@.str.3 = private unnamed_addr constant [27 x i8] c"Sorting list of %d floats\0A\00", align 1
@.str.4 = private unnamed_addr constant [16 x i8] c"FileInput: %ld\0A\00", align 1
@.str.5 = private unnamed_addr constant [13 x i8] c"memcpy: %ld\0A\00", align 1
@.str.6 = private unnamed_addr constant [32 x i8] c"Sorting on multiple cores: %ld\0A\00", align 1
@.str.7 = private unnamed_addr constant [22 x i8] c"Sorting on FPGA: %ld\0A\00", align 1
@.str.8 = private unnamed_addr constant [29 x i8] c"Sorting on single-core: %ld\0A\00", align 1
@.str.9 = private unnamed_addr constant [4 x i8] c"%f \00", align 1
@.str.10 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str.11 = private unnamed_addr constant [18 x i8] c"Verifying Result\0A\00", align 1
@.str.12 = private unnamed_addr constant [14 x i8] c"Failed at %d\0A\00", align 1
@.str.13 = private unnamed_addr constant [6 x i8] c"Pass\0A\00", align 1

; Function Attrs: noinline nounwind ssp uwtable
define i32 @_Z16compare_functionPKvS0_(i8*, i8*) #0 {
  %3 = alloca i32, align 4
  %4 = alloca i8*, align 8
  %5 = alloca i8*, align 8
  store i8* %0, i8** %4, align 8
  store i8* %1, i8** %5, align 8
  %6 = load i8*, i8** %4, align 8
  %7 = bitcast i8* %6 to float*
  %8 = load float, float* %7, align 4
  %9 = load i8*, i8** %5, align 8
  %10 = bitcast i8* %9 to float*
  %11 = load float, float* %10, align 4
  %12 = fcmp olt float %8, %11
  br i1 %12, label %13, label %14

; <label>:13:                                     ; preds = %2
  store i32 -1, i32* %3, align 4
  br label %24

; <label>:14:                                     ; preds = %2
  %15 = load i8*, i8** %4, align 8
  %16 = bitcast i8* %15 to float*
  %17 = load float, float* %16, align 4
  %18 = load i8*, i8** %5, align 8
  %19 = bitcast i8* %18 to float*
  %20 = load float, float* %19, align 4
  %21 = fcmp ogt float %17, %20
  br i1 %21, label %22, label %23

; <label>:22:                                     ; preds = %14
  store i32 1, i32* %3, align 4
  br label %24

; <label>:23:                                     ; preds = %14
  store i32 0, i32* %3, align 4
  br label %24

; <label>:24:                                     ; preds = %23, %22, %13
  %25 = load i32, i32* %3, align 4
  ret i32 %25
}

; Function Attrs: noinline norecurse ssp uwtable
define i32 @main(i32, i8**) #1 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i8**, align 8
  %6 = alloca %struct.timeval, align 8
  %7 = alloca %struct.timeval, align 8
  %8 = alloca %struct.timeval, align 8
  %9 = alloca %struct.timeval, align 8
  %10 = alloca i32, align 4
  %11 = alloca i32, align 4
  %12 = alloca i32, align 4
  %13 = alloca %struct.__sFILE*, align 8
  %14 = alloca i32, align 4
  %15 = alloca i32, align 4
  %16 = alloca float*, align 8
  %17 = alloca float*, align 8
  %18 = alloca i32, align 4
  %19 = alloca float, align 4
  store i32 0, i32* %3, align 4
  store i32 %0, i32* %4, align 4
  store i8** %1, i8*** %5, align 8
  store i32 0, i32* %10, align 4
  %20 = call i32 @gettimeofday(%struct.timeval* %8, i8* null)
  %21 = call i32 @gettimeofday(%struct.timeval* %6, i8* null)
  %22 = load i32, i32* %4, align 4
  %23 = icmp slt i32 %22, 3
  br i1 %23, label %24, label %30

; <label>:24:                                     ; preds = %2
  %25 = load %struct.__sFILE*, %struct.__sFILE** @__stderrp, align 8
  %26 = load i8**, i8*** %5, align 8
  %27 = getelementptr inbounds i8*, i8** %26, i64 0
  %28 = load i8*, i8** %27, align 8
  %29 = call i32 (%struct.__sFILE*, i8*, ...) @fprintf(%struct.__sFILE* %25, i8* getelementptr inbounds ([46 x i8], [46 x i8]* @.str, i32 0, i32 0), i8* %28)
  br label %30

; <label>:30:                                     ; preds = %24, %2
  %31 = load i8**, i8*** %5, align 8
  %32 = getelementptr inbounds i8*, i8** %31, i64 2
  %33 = load i8*, i8** %32, align 8
  %34 = call i32 @atoi(i8* %33)
  store i32 %34, i32* %15, align 4
  %35 = load i8**, i8*** %5, align 8
  %36 = getelementptr inbounds i8*, i8** %35, i64 1
  %37 = load i8*, i8** %36, align 8
  %38 = call %struct.__sFILE* @"\01_fopen"(i8* %37, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.1, i32 0, i32 0))
  store %struct.__sFILE* %38, %struct.__sFILE** %13, align 8
  %39 = load i32, i32* %4, align 4
  %40 = icmp eq i32 %39, 4
  br i1 %40, label %41, label %46

; <label>:41:                                     ; preds = %30
  %42 = load i8**, i8*** %5, align 8
  %43 = getelementptr inbounds i8*, i8** %42, i64 3
  %44 = load i8*, i8** %43, align 8
  %45 = call i32 @atoi(i8* %44)
  store i32 %45, i32* %10, align 4
  br label %46

; <label>:46:                                     ; preds = %41, %30
  %47 = load %struct.__sFILE*, %struct.__sFILE** %13, align 8
  %48 = icmp eq %struct.__sFILE* %47, null
  br i1 %48, label %49, label %55

; <label>:49:                                     ; preds = %46
  %50 = load %struct.__sFILE*, %struct.__sFILE** @__stderrp, align 8
  %51 = load i8**, i8*** %5, align 8
  %52 = getelementptr inbounds i8*, i8** %51, i64 1
  %53 = load i8*, i8** %52, align 8
  %54 = call i32 (%struct.__sFILE*, i8*, ...) @fprintf(%struct.__sFILE* %50, i8* getelementptr inbounds ([16 x i8], [16 x i8]* @.str.2, i32 0, i32 0), i8* %53)
  call void @exit(i32 1) #6
  unreachable

; <label>:55:                                     ; preds = %46
  store i32 0, i32* %18, align 4
  %56 = load %struct.__sFILE*, %struct.__sFILE** @__stderrp, align 8
  %57 = load i32, i32* %15, align 4
  %58 = call i32 (%struct.__sFILE*, i8*, ...) @fprintf(%struct.__sFILE* %56, i8* getelementptr inbounds ([27 x i8], [27 x i8]* @.str.3, i32 0, i32 0), i32 %57)
  %59 = load i32, i32* %15, align 4
  %60 = sext i32 %59 to i64
  %61 = mul i64 %60, 4
  %62 = trunc i64 %61 to i32
  store i32 %62, i32* %14, align 4
  %63 = load i32, i32* %14, align 4
  %64 = sext i32 %63 to i64
  %65 = call i8* @malloc(i64 %64) #7
  %66 = bitcast i8* %65 to float*
  store float* %66, float** %16, align 8
  %67 = load i32, i32* %14, align 4
  %68 = sext i32 %67 to i64
  %69 = call i8* @malloc(i64 %68) #7
  %70 = bitcast i8* %69 to float*
  store float* %70, float** %17, align 8
  %71 = load float*, float** %16, align 8
  %72 = bitcast float* %71 to i8*
  %73 = load i32, i32* %15, align 4
  %74 = sext i32 %73 to i64
  %75 = load %struct.__sFILE*, %struct.__sFILE** %13, align 8
  %76 = call i64 @fread(i8* %72, i64 4, i64 %74, %struct.__sFILE* %75)
  %77 = trunc i64 %76 to i32
  store i32 %77, i32* %12, align 4
  %78 = load %struct.__sFILE*, %struct.__sFILE** %13, align 8
  %79 = call i32 @fclose(%struct.__sFILE* %78)
  %80 = call i32 @gettimeofday(%struct.timeval* %7, i8* null)
  %81 = load %struct.__sFILE*, %struct.__sFILE** @__stderrp, align 8
  %82 = getelementptr inbounds %struct.timeval, %struct.timeval* %7, i32 0, i32 0
  %83 = load i64, i64* %82, align 8
  %84 = mul nsw i64 %83, 1000000
  %85 = getelementptr inbounds %struct.timeval, %struct.timeval* %7, i32 0, i32 1
  %86 = load i32, i32* %85, align 8
  %87 = sext i32 %86 to i64
  %88 = add nsw i64 %84, %87
  %89 = getelementptr inbounds %struct.timeval, %struct.timeval* %6, i32 0, i32 0
  %90 = load i64, i64* %89, align 8
  %91 = mul nsw i64 %90, 1000000
  %92 = getelementptr inbounds %struct.timeval, %struct.timeval* %6, i32 0, i32 1
  %93 = load i32, i32* %92, align 8
  %94 = sext i32 %93 to i64
  %95 = add nsw i64 %91, %94
  %96 = sub nsw i64 %88, %95
  %97 = call i32 (%struct.__sFILE*, i8*, ...) @fprintf(%struct.__sFILE* %81, i8* getelementptr inbounds ([16 x i8], [16 x i8]* @.str.4, i32 0, i32 0), i64 %96)
  %98 = call i32 @gettimeofday(%struct.timeval* %6, i8* null)
  %99 = load float*, float** %17, align 8
  %100 = bitcast float* %99 to i8*
  %101 = load float*, float** %16, align 8
  %102 = bitcast float* %101 to i8*
  %103 = load i32, i32* %14, align 4
  %104 = sext i32 %103 to i64
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %100, i8* %102, i64 %104, i32 4, i1 false)
  %105 = call i32 @gettimeofday(%struct.timeval* %7, i8* null)
  %106 = load %struct.__sFILE*, %struct.__sFILE** @__stderrp, align 8
  %107 = getelementptr inbounds %struct.timeval, %struct.timeval* %7, i32 0, i32 0
  %108 = load i64, i64* %107, align 8
  %109 = mul nsw i64 %108, 1000000
  %110 = getelementptr inbounds %struct.timeval, %struct.timeval* %7, i32 0, i32 1
  %111 = load i32, i32* %110, align 8
  %112 = sext i32 %111 to i64
  %113 = add nsw i64 %109, %112
  %114 = getelementptr inbounds %struct.timeval, %struct.timeval* %6, i32 0, i32 0
  %115 = load i64, i64* %114, align 8
  %116 = mul nsw i64 %115, 1000000
  %117 = getelementptr inbounds %struct.timeval, %struct.timeval* %6, i32 0, i32 1
  %118 = load i32, i32* %117, align 8
  %119 = sext i32 %118 to i64
  %120 = add nsw i64 %116, %119
  %121 = sub nsw i64 %113, %120
  %122 = call i32 (%struct.__sFILE*, i8*, ...) @fprintf(%struct.__sFILE* %106, i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str.5, i32 0, i32 0), i64 %121)
  %123 = load i32, i32* %10, align 4
  switch i32 %123, label %170 [
    i32 1, label %124
    i32 2, label %147
  ]

; <label>:124:                                    ; preds = %55
  %125 = call i32 @gettimeofday(%struct.timeval* %6, i8* null)
  %126 = load i32, i32* %15, align 4
  %127 = load float*, float** %17, align 8
  %128 = call i32 @pthread_sort(i32 %126, float* %127)
  %129 = call i32 @gettimeofday(%struct.timeval* %7, i8* null)
  %130 = load %struct.__sFILE*, %struct.__sFILE** @__stderrp, align 8
  %131 = getelementptr inbounds %struct.timeval, %struct.timeval* %7, i32 0, i32 0
  %132 = load i64, i64* %131, align 8
  %133 = mul nsw i64 %132, 1000000
  %134 = getelementptr inbounds %struct.timeval, %struct.timeval* %7, i32 0, i32 1
  %135 = load i32, i32* %134, align 8
  %136 = sext i32 %135 to i64
  %137 = add nsw i64 %133, %136
  %138 = getelementptr inbounds %struct.timeval, %struct.timeval* %6, i32 0, i32 0
  %139 = load i64, i64* %138, align 8
  %140 = mul nsw i64 %139, 1000000
  %141 = getelementptr inbounds %struct.timeval, %struct.timeval* %6, i32 0, i32 1
  %142 = load i32, i32* %141, align 8
  %143 = sext i32 %142 to i64
  %144 = add nsw i64 %140, %143
  %145 = sub nsw i64 %137, %144
  %146 = call i32 (%struct.__sFILE*, i8*, ...) @fprintf(%struct.__sFILE* %130, i8* getelementptr inbounds ([32 x i8], [32 x i8]* @.str.6, i32 0, i32 0), i64 %145)
  br label %194

; <label>:147:                                    ; preds = %55
  %148 = call i32 @gettimeofday(%struct.timeval* %6, i8* null)
  %149 = load i32, i32* %15, align 4
  %150 = load float*, float** %17, align 8
  %151 = call i32 @fpga_sort(i32 %149, float* %150)
  %152 = call i32 @gettimeofday(%struct.timeval* %7, i8* null)
  %153 = load %struct.__sFILE*, %struct.__sFILE** @__stderrp, align 8
  %154 = getelementptr inbounds %struct.timeval, %struct.timeval* %7, i32 0, i32 0
  %155 = load i64, i64* %154, align 8
  %156 = mul nsw i64 %155, 1000000
  %157 = getelementptr inbounds %struct.timeval, %struct.timeval* %7, i32 0, i32 1
  %158 = load i32, i32* %157, align 8
  %159 = sext i32 %158 to i64
  %160 = add nsw i64 %156, %159
  %161 = getelementptr inbounds %struct.timeval, %struct.timeval* %6, i32 0, i32 0
  %162 = load i64, i64* %161, align 8
  %163 = mul nsw i64 %162, 1000000
  %164 = getelementptr inbounds %struct.timeval, %struct.timeval* %6, i32 0, i32 1
  %165 = load i32, i32* %164, align 8
  %166 = sext i32 %165 to i64
  %167 = add nsw i64 %163, %166
  %168 = sub nsw i64 %160, %167
  %169 = call i32 (%struct.__sFILE*, i8*, ...) @fprintf(%struct.__sFILE* %153, i8* getelementptr inbounds ([22 x i8], [22 x i8]* @.str.7, i32 0, i32 0), i64 %168)
  br label %194

; <label>:170:                                    ; preds = %55
  %171 = call i32 @gettimeofday(%struct.timeval* %6, i8* null)
  %172 = load float*, float** %17, align 8
  %173 = bitcast float* %172 to i8*
  %174 = load i32, i32* %15, align 4
  %175 = sext i32 %174 to i64
  call void @qsort(i8* %173, i64 %175, i64 4, i32 (i8*, i8*)* @_Z16compare_functionPKvS0_)
  %176 = call i32 @gettimeofday(%struct.timeval* %7, i8* null)
  %177 = load %struct.__sFILE*, %struct.__sFILE** @__stderrp, align 8
  %178 = getelementptr inbounds %struct.timeval, %struct.timeval* %7, i32 0, i32 0
  %179 = load i64, i64* %178, align 8
  %180 = mul nsw i64 %179, 1000000
  %181 = getelementptr inbounds %struct.timeval, %struct.timeval* %7, i32 0, i32 1
  %182 = load i32, i32* %181, align 8
  %183 = sext i32 %182 to i64
  %184 = add nsw i64 %180, %183
  %185 = getelementptr inbounds %struct.timeval, %struct.timeval* %6, i32 0, i32 0
  %186 = load i64, i64* %185, align 8
  %187 = mul nsw i64 %186, 1000000
  %188 = getelementptr inbounds %struct.timeval, %struct.timeval* %6, i32 0, i32 1
  %189 = load i32, i32* %188, align 8
  %190 = sext i32 %189 to i64
  %191 = add nsw i64 %187, %190
  %192 = sub nsw i64 %184, %191
  %193 = call i32 (%struct.__sFILE*, i8*, ...) @fprintf(%struct.__sFILE* %177, i8* getelementptr inbounds ([29 x i8], [29 x i8]* @.str.8, i32 0, i32 0), i64 %192)
  br label %194

; <label>:194:                                    ; preds = %170, %147, %124
  store i32 0, i32* %11, align 4
  br label %195

; <label>:195:                                    ; preds = %207, %194
  %196 = load i32, i32* %11, align 4
  %197 = load i32, i32* %15, align 4
  %198 = icmp slt i32 %196, %197
  br i1 %198, label %199, label %210

; <label>:199:                                    ; preds = %195
  %200 = load float*, float** %16, align 8
  %201 = load i32, i32* %11, align 4
  %202 = sext i32 %201 to i64
  %203 = getelementptr inbounds float, float* %200, i64 %202
  %204 = load float, float* %203, align 4
  %205 = fpext float %204 to double
  %206 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.9, i32 0, i32 0), double %205)
  br label %207

; <label>:207:                                    ; preds = %199
  %208 = load i32, i32* %11, align 4
  %209 = add nsw i32 %208, 1
  store i32 %209, i32* %11, align 4
  br label %195

; <label>:210:                                    ; preds = %195
  %211 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.10, i32 0, i32 0))
  store i32 0, i32* %11, align 4
  br label %212

; <label>:212:                                    ; preds = %224, %210
  %213 = load i32, i32* %11, align 4
  %214 = load i32, i32* %15, align 4
  %215 = icmp slt i32 %213, %214
  br i1 %215, label %216, label %227

; <label>:216:                                    ; preds = %212
  %217 = load float*, float** %17, align 8
  %218 = load i32, i32* %11, align 4
  %219 = sext i32 %218 to i64
  %220 = getelementptr inbounds float, float* %217, i64 %219
  %221 = load float, float* %220, align 4
  %222 = fpext float %221 to double
  %223 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.9, i32 0, i32 0), double %222)
  br label %224

; <label>:224:                                    ; preds = %216
  %225 = load i32, i32* %11, align 4
  %226 = add nsw i32 %225, 1
  store i32 %226, i32* %11, align 4
  br label %212

; <label>:227:                                    ; preds = %212
  %228 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.10, i32 0, i32 0))
  %229 = load %struct.__sFILE*, %struct.__sFILE** @__stderrp, align 8
  %230 = call i32 (%struct.__sFILE*, i8*, ...) @fprintf(%struct.__sFILE* %229, i8* getelementptr inbounds ([18 x i8], [18 x i8]* @.str.11, i32 0, i32 0))
  %231 = call i32 @gettimeofday(%struct.timeval* %6, i8* null)
  %232 = load float*, float** %16, align 8
  %233 = bitcast float* %232 to i8*
  %234 = load i32, i32* %15, align 4
  %235 = sext i32 %234 to i64
  call void @qsort(i8* %233, i64 %235, i64 4, i32 (i8*, i8*)* @_Z16compare_functionPKvS0_)
  %236 = call i32 @gettimeofday(%struct.timeval* %7, i8* null)
  %237 = load %struct.__sFILE*, %struct.__sFILE** @__stderrp, align 8
  %238 = getelementptr inbounds %struct.timeval, %struct.timeval* %7, i32 0, i32 0
  %239 = load i64, i64* %238, align 8
  %240 = mul nsw i64 %239, 1000000
  %241 = getelementptr inbounds %struct.timeval, %struct.timeval* %7, i32 0, i32 1
  %242 = load i32, i32* %241, align 8
  %243 = sext i32 %242 to i64
  %244 = add nsw i64 %240, %243
  %245 = getelementptr inbounds %struct.timeval, %struct.timeval* %6, i32 0, i32 0
  %246 = load i64, i64* %245, align 8
  %247 = mul nsw i64 %246, 1000000
  %248 = getelementptr inbounds %struct.timeval, %struct.timeval* %6, i32 0, i32 1
  %249 = load i32, i32* %248, align 8
  %250 = sext i32 %249 to i64
  %251 = add nsw i64 %247, %250
  %252 = sub nsw i64 %244, %251
  %253 = call i32 (%struct.__sFILE*, i8*, ...) @fprintf(%struct.__sFILE* %237, i8* getelementptr inbounds ([29 x i8], [29 x i8]* @.str.8, i32 0, i32 0), i64 %252)
  %254 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.10, i32 0, i32 0))
  store i32 0, i32* %11, align 4
  br label %255

; <label>:255:                                    ; preds = %273, %227
  %256 = load i32, i32* %11, align 4
  %257 = load i32, i32* %15, align 4
  %258 = icmp slt i32 %256, %257
  br i1 %258, label %259, label %276

; <label>:259:                                    ; preds = %255
  %260 = load float*, float** %17, align 8
  %261 = load i32, i32* %11, align 4
  %262 = sext i32 %261 to i64
  %263 = getelementptr inbounds float, float* %260, i64 %262
  %264 = load float, float* %263, align 4
  %265 = load float*, float** %16, align 8
  %266 = load i32, i32* %11, align 4
  %267 = sext i32 %266 to i64
  %268 = getelementptr inbounds float, float* %265, i64 %267
  %269 = load float, float* %268, align 4
  %270 = fcmp une float %264, %269
  br i1 %270, label %271, label %272

; <label>:271:                                    ; preds = %259
  br label %276

; <label>:272:                                    ; preds = %259
  br label %273

; <label>:273:                                    ; preds = %272
  %274 = load i32, i32* %11, align 4
  %275 = add nsw i32 %274, 1
  store i32 %275, i32* %11, align 4
  br label %255

; <label>:276:                                    ; preds = %271, %255
  %277 = load i32, i32* %11, align 4
  %278 = load i32, i32* %15, align 4
  %279 = icmp ne i32 %277, %278
  br i1 %279, label %280, label %284

; <label>:280:                                    ; preds = %276
  %281 = load %struct.__sFILE*, %struct.__sFILE** @__stderrp, align 8
  %282 = load i32, i32* %11, align 4
  %283 = call i32 (%struct.__sFILE*, i8*, ...) @fprintf(%struct.__sFILE* %281, i8* getelementptr inbounds ([14 x i8], [14 x i8]* @.str.12, i32 0, i32 0), i32 %282)
  br label %287

; <label>:284:                                    ; preds = %276
  %285 = load %struct.__sFILE*, %struct.__sFILE** @__stderrp, align 8
  %286 = call i32 (%struct.__sFILE*, i8*, ...) @fprintf(%struct.__sFILE* %285, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.13, i32 0, i32 0))
  br label %287

; <label>:287:                                    ; preds = %284, %280
  %288 = call i32 @gettimeofday(%struct.timeval* %9, i8* null)
  %289 = load float*, float** %16, align 8
  %290 = bitcast float* %289 to i8*
  call void @free(i8* %290)
  %291 = load float*, float** %17, align 8
  %292 = bitcast float* %291 to i8*
  call void @free(i8* %292)
  %293 = load i32, i32* %3, align 4
  ret i32 %293
}

declare i32 @gettimeofday(%struct.timeval*, i8*) #2

declare i32 @fprintf(%struct.__sFILE*, i8*, ...) #2

declare i32 @atoi(i8*) #2

declare %struct.__sFILE* @"\01_fopen"(i8*, i8*) #2

; Function Attrs: noreturn
declare void @exit(i32) #3

; Function Attrs: allocsize(0)
declare i8* @malloc(i64) #4

declare i64 @fread(i8*, i64, i64, %struct.__sFILE*) #2

declare i32 @fclose(%struct.__sFILE*) #2

; Function Attrs: argmemonly nounwind
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* nocapture writeonly, i8* nocapture readonly, i64, i32, i1) #5

declare i32 @pthread_sort(i32, float*) #2

declare i32 @fpga_sort(i32, float*) #2

declare void @qsort(i8*, i64, i64, i32 (i8*, i8*)*) #2

declare i32 @printf(i8*, ...) #2

declare void @free(i8*) #2

attributes #0 = { noinline nounwind ssp uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="penryn" "target-features"="+cx16,+fxsr,+mmx,+sse,+sse2,+sse3,+sse4.1,+ssse3,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { noinline norecurse ssp uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="penryn" "target-features"="+cx16,+fxsr,+mmx,+sse,+sse2,+sse3,+sse4.1,+ssse3,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="penryn" "target-features"="+cx16,+fxsr,+mmx,+sse,+sse2,+sse3,+sse4.1,+ssse3,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { noreturn "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="penryn" "target-features"="+cx16,+fxsr,+mmx,+sse,+sse2,+sse3,+sse4.1,+ssse3,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { allocsize(0) "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="penryn" "target-features"="+cx16,+fxsr,+mmx,+sse,+sse2,+sse3,+sse4.1,+ssse3,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #5 = { argmemonly nounwind }
attributes #6 = { noreturn }
attributes #7 = { allocsize(0) }

!llvm.module.flags = !{!0}
!llvm.ident = !{!1}

!0 = !{i32 1, !"PIC Level", i32 2}
!1 = !{!"Apple LLVM version 9.0.0 (clang-900.0.39.2)"}
