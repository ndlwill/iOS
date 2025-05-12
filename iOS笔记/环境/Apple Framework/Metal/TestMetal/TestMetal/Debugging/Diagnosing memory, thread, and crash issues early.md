# Diagnosing memory, thread, and crash issues early
Identify runtime crashes and undefined behaviors in your app during testing using Xcode’s sanitizer tools.

Xcode provides several runtime tools to identify potential issues in your code:
* Address Sanitizer—The ASan tool identifies potential memory-related corruption issues.
* Thread Sanitizer—The TSan tool detects race conditions between threads.
* Main Thread Checker—This tool verifies that system APIs that must run on the main thread actually do run on that thread.
* Undefined Behavior Sanitizer—The UBSan tool detects divide-by-zero errors, attempts to access memory using a misaligned
pointer, and other undefined behaviors.

These are LLVM-based tools that add specific checks to your code.
You enable them at build time using the Xcode scheme editor.
Select the appropriate scheme for your project and choose Product > Scheme > Edit Scheme to display the scheme editor.
Select the Run or Test schemes, navigate to the Diagnostics section, and select the sanitizers you want to run.

Note
The sanitizer tools support all C-based languages.
The tools also support the Swift language, with the exception of the Undefined Behavior Sanitizer tool,
which supports only C-based languages.

## Locate memory corruption issues in your code
Accessing memory improperly can introduce unexpected issues into your code, and even pose a security threat.
The Address Sanitizer tool detects memory-access attempts that don’t belong to an allocated block.
To enable this tool, select Address Sanitizer from the Diagnostics section of the appropriate scheme.

To enable ASan from the command line, use the following flags:
* -fsanitize=address (clang)
* -sanitize=address (swiftc)
* -enableAddressSanitizer YES (xcodebuild)

The Address Sanitizer tool replaces the malloc(_:) and free(_:) functions with custom implementations.
The custom malloc(_:) function surrounds a requested memory block with special off-limits regions, and reports attempts to
access those regions.
The free(_:) function places a deallocated block into a special quarantine queue, and reports attempts to access that
quarantined memory.

Important
Address Sanitizer doesn’t detect memory leaks, attempts to access uninitialized memory, or integer overflow errors.
Use Instruments and the other sanitizer tools to find additional errors.

For most use cases, the overhead that Address Sanitizer adds to your code should be acceptable for daily development.
Running your code with Address Sanitizer increases memory usage by two to three times,
and also adds 2x to 5x slowdown of your code.
To improve your code’s memory usage, compile your code with the -O1 optimization.

## Detect data races among your app’s threads
Race conditions occur when multiple threads access the same memory without proper synchronization.
Race conditions are difficult to detect during regular testing because they don’t occur consistently.
However, fixing them is important because they cause your code to behave unpredictably,
and may even lead to memory corruption.

To detect race conditions and other thread-related issues,
enable the Thread Sanitizer tool from the Diagnostics section of the appropriate build scheme.

To enable TSan from the command line, use the following flags:
* -fsanitize=thread (clang)
* -santize=thread (swiftc)
* -enableThreadSanitizer YES (xcodebuild)

Important
You can’t use Thread Sanitizer to diagnose iOS, tvOS, and watchOS apps running on a device.
Use Thread Sanitizer only on your 64-bit macOS app,
or to diagnose your 64-bit iOS, tvOS, or watchOS app running in Simulator.
