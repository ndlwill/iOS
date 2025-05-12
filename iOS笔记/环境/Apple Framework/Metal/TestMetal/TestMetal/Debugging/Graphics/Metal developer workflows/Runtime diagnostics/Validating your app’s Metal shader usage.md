# Validating your app’s Metal shader usage
Catch common shader runtime issues using Shader Validation while your app is running.

The Shader Validation layer detects errors only discoverable during shader execution,
like out-of-bounds memory accesses, attempts to access nil textures, and others. 
It’s similar to Address Sanitizer for general runtime issues
You can enable Shader Validation using the runtime diagnostics options in Xcode, or by using environment variables.

Address Sanitizer（ASan）

*Important*

The Shader Validation layer has a corresponding impact on GPU performance, and shaders may take longer to compile in runtime.
This layer adds instrumentation code to all your GPU functions, which increases the number of times they access memory.

[Debug GPU-side errors in Metal](https://developer.apple.com/videos/play/wwdc2020/10616/)

## Enable Shader Validation in Xcode
Follow these steps to enable Shader Validation using the runtime diagnostics options in the scheme settings:
1. In the Xcode toolbar, choose Edit Scheme from the Scheme menu. Alternatively, choose Product > Scheme > Edit Scheme.
2. In the scheme action panel, select Run.
3. In the action setting tab, click Diagnostics.
4. Select Shader Validation to enable it, and click Close.

Now, Shader Validation is enabled each time you run your scheme.
In addition, you can create breakpoints for shader errors by clicking the arrow next to the Shader Validation checkbox.

## View Shader Validation errors
After enabling Shader Validation, if Metal encounters errors while executing the commands in a command buffer,
these details appear in Xcode.

You can find the breakpoint in the Breakpoint navigator if you want to modify or remove it in the future.

If you discover an error in your shader, consider taking a capture and investigating with the shader debugger

## Enable Shader Validation with environment variables
You can also enable Shader Validation by setting the following environment variables on your Metal app:

MTL_SHADER_VALIDATION=1
Enables all Shader Validation tests.

MTL_SHADER_VALIDATION_ENABLE_ERROR_REPORTING=1
Enables Shader Validation error reporting.

MTL_SHADER_VALIDATION_COMPILER_INLINING
Determines the amount of code inlining that occurs.
Possible values are default and full.
Setting the value to full forces inlining.
Increasing inlining may result in improved runtime performance at the cost of compile time performance.
Decreasing inlining may result in improved compile time performance at the cost of runtime performance.

MTL_SHADER_VALIDATION_FAIL_MODE
Sets the behavior for handling invalid accesses.
Possible values are zerofill (default) and allow.
zerofill causes invalid reads to return 0, and drops any invalid writes.
allow allows an invalid read or write, but may result in command buffer failure, depending on the platform.
It also reduces compile and runtime performance impact.

MTL_SHADER_VALIDATION_GLOBAL_MEMORY=1
Shader Validation checks all global memory accesses.
Accessing invalid memory follows the behavior that MTL_SHADER_VALIDATION_FAIL_MODE specifies.

MTL_SHADER_VALIDATION_THREADGROUP_MEMORY=1
Shader Validation checks all threadgroup memory accesses.
Accessing invalid memory follows the behavior that MTL_SHADER_VALIDATION_FAIL_MODE specifies.

MTL_SHADER_VALIDATION_TEXTURE_USAGE=1
Shader Validation checks all texture member functions (such as read, write, get_width).
Accessing a nil texture instance follows the behavior that MTL_SHADER_VALIDATION_FAIL_MODE specifies.

MTL_SHADER_VALIDATION_STACK_OVERFLOW=1
Shader Validation checks all indirect calls (calls by function pointer, visible functions, intersection functions,
and dynamic libraries), as well as recursive calls.
If the call stack depth for such functions exceeds the value in maxCallStackDepth for that stage,
an error occurs and the system skips the function call.

If you discover an error in your shader, consider taking a capture and investigating with the Metal debugger
