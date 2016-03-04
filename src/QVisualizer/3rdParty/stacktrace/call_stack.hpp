/* Copyright (c) 2009, Fredrik Orderud
   License: BSD licence (http://www.opensource.org/licenses/bsd-license.php) */

#ifndef _call_stack_h
#define _call_stack_h
#include <string>
#include <vector>
#include <sstream>

namespace stacktrace {

/*
 * Functions to set a fake call stack pointer for use in printing a stack trace.
 * Called on Windows only after a signal / SEH handler is invoked to get a stack pointer.
 */
void* getFakeCallStackPointer();
void setFakeCallStackPointer(void* ptr);

/** Call-stack entry datastructure. */
struct entry {
    /** Default constructor that clears all fields. */
    entry () : line(0), address(NULL) {
    }

    std::string file;     ///< filename
    size_t      line;     ///< line number
    std::string lineStr;  ///< line number string (not always set)
    std::string function; ///< name of function or method
    void* address;        ///< memory address of stack pointer (not always set)

    /** Serialize entry into a text string. */
    std::string to_string() const {
        std::ostringstream os;
        os << file;
        if (line > 0) {
            os << " (" << line << ")";
        } else if (!lineStr.empty()) {
            os << " (" << lineStr << ")";
        }
        os << ": " << function;
        return os.str();
    }
};

/** Stack-trace base class, for retrieving the current call-stack. */
class call_stack {
public:
    /** Stack-trace consructor.
     \param num_discard - number of stack entries to discard at the top. */
    call_stack (const size_t num_discard = 0);

    virtual ~call_stack () throw();

    /** Serializes the entire call-stack into a text string. */
    std::string to_string () const {
        std::ostringstream os;
        for (size_t i = 0; i < stack.size(); i++)
            os << stack[i].to_string() << std::endl;
        return os.str();
    }

    /** Call stack. */
    std::vector<entry> stack;
};

} // namespace stacktrace

#endif // _call_stack_h
