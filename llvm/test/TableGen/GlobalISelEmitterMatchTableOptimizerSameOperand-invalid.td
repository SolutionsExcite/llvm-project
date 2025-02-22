// RUN: llvm-tblgen %s -gen-global-isel -optimize-match-table=true -I %p/../../include -I %p/Common -o - | FileCheck %s

include "llvm/Target/Target.td"
include "GlobalISelEmitterCommon.td"

def InstTwoOperands : I<(outs GPR32:$dst), (ins GPR32:$src1, GPR32:$src2), []>;
def InstThreeOperands : I<(outs GPR32:$dst), (ins GPR32:$cond, GPR32:$src,GPR32:$src2), []>;

// CHECK:         GIM_Try, /*On fail goto*//*Label 0*/ 219,
// CHECK-NEXT:      GIM_CheckOpcode, /*MI*/0, TargetOpcode::G_SELECT,
// CHECK-NEXT:      GIM_CheckType, /*MI*/0, /*Op*/0, /*Type*/GILLT_s32,
// CHECK-NEXT:      GIM_CheckType, /*MI*/0, /*Op*/1, /*Type*/GILLT_s32,
// CHECK-NEXT:      GIM_CheckType, /*MI*/0, /*Op*/2, /*Type*/GILLT_s32,
// CHECK-NEXT:      GIM_Try, /*On fail goto*//*Label 1*/ 189,
// CHECK-NEXT:        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/MyTarget::GPR32RegClassID,
// CHECK-NEXT:        GIM_CheckIsSameOperand, /*MI*/0, /*OpIdx*/3, /*OtherMI*/2, /*OtherOpIdx*/2,
// CHECK-NEXT:        GIM_Try, /*On fail goto*//*Label 2*/ 108, // Rule ID 1 //
// CHECK-NEXT:          GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/1, // MIs[1]
// CHECK-NEXT:          GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_ICMP,
// CHECK-NEXT:          GIM_CheckType, /*MI*/1, /*Op*/2, /*Type*/GILLT_s32,
// CHECK-NEXT:          GIM_CheckType, /*MI*/1, /*Op*/3, /*Type*/GILLT_s32,
// CHECK-NEXT:          // MIs[1] Operand 1
// CHECK-NEXT:          GIM_CheckCmpPredicate, /*MI*/1, /*Op*/1, /*Predicate*/CmpInst::ICMP_EQ,
// CHECK-NEXT:          GIM_CheckRegBankForClass, /*MI*/1, /*Op*/2, /*RC*/MyTarget::GPR32RegClassID,
// CHECK-NEXT:          GIM_CheckConstantInt, /*MI*/1, /*Op*/3, 0,
// CHECK-NEXT:          GIM_RecordInsn, /*DefineMI*/2, /*MI*/0, /*OpIdx*/2, // MIs[2]
// CHECK-NEXT:          GIM_CheckOpcode, /*MI*/2, TargetOpcode::G_SUB,
// CHECK-NEXT:          GIM_CheckType, /*MI*/2, /*Op*/1, /*Type*/GILLT_s32,
// CHECK-NEXT:          GIM_CheckType, /*MI*/2, /*Op*/2, /*Type*/GILLT_s32,
// CHECK-NEXT:          GIM_CheckRegBankForClass, /*MI*/2, /*Op*/1, /*RC*/MyTarget::GPR32RegClassID,
// CHECK-NEXT:          GIM_CheckRegBankForClass, /*MI*/2, /*Op*/2, /*RC*/MyTarget::GPR32RegClassID,
// CHECK-NEXT:          GIM_CheckIsSafeToFold, /*InsnID*/1,
// CHECK-NEXT:          GIM_CheckIsSafeToFold, /*InsnID*/2,
// CHECK-NEXT:          // (select:{ *:[i32] } (setcc:{ *:[i32] } GPR32:{ *:[i32] }:$cond, 0:{ *:[i32] }, SETEQ:{ *:[Other] }), (sub:{ *:[i32] } GPR32:{ *:[i32] }:$src1, GPR32:{ *:[i32] }:$src2), GPR32:{ *:[i32] }:$src2)  =>  (InstThreeOperands:{ *:[i32] } GPR32:{ *:[i32] }:$cond, GPR32:{ *:[i32] }:$src1, GPR32:{ *:[i32] }:$src2)
// CHECK-NEXT:          GIR_BuildMI, /*InsnID*/0, /*Opcode*/MyTarget::InstThreeOperands,
// CHECK-NEXT:          GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // DstI[dst]
// CHECK-NEXT:          GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/1, /*OpIdx*/2, // cond
// CHECK-NEXT:          GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/2, /*OpIdx*/1, // src1
// CHECK-NEXT:          GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/2, /*OpIdx*/2, // src2
// CHECK-NEXT:          GIR_EraseFromParent, /*InsnID*/0,
// CHECK-NEXT:          GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
// CHECK-NEXT:          // GIR_Coverage, 1,
// CHECK-NEXT:          GIR_Done,
// CHECK-NEXT:        // Label 2: @108
// CHECK-NEXT:        GIM_Try, /*On fail goto*//*Label 3*/ 188, // Rule ID 2 //
// CHECK-NEXT:          GIM_RecordInsn, /*DefineMI*/1, /*MI*/0, /*OpIdx*/1, // MIs[1]
// CHECK-NEXT:          GIM_CheckOpcode, /*MI*/1, TargetOpcode::G_ICMP,
// CHECK-NEXT:          GIM_CheckType, /*MI*/1, /*Op*/2, /*Type*/GILLT_s32,
// CHECK-NEXT:          GIM_CheckType, /*MI*/1, /*Op*/3, /*Type*/GILLT_s32,
// CHECK-NEXT:          // MIs[1] Operand 1
// CHECK-NEXT:          GIM_CheckCmpPredicate, /*MI*/1, /*Op*/1, /*Predicate*/CmpInst::ICMP_NE,
// CHECK-NEXT:          GIM_CheckRegBankForClass, /*MI*/1, /*Op*/2, /*RC*/MyTarget::GPR32RegClassID,
// CHECK-NEXT:          GIM_CheckConstantInt, /*MI*/1, /*Op*/3, 0,
// CHECK-NEXT:          GIM_RecordInsn, /*DefineMI*/2, /*MI*/0, /*OpIdx*/2, // MIs[2]
// CHECK-NEXT:          GIM_CheckOpcode, /*MI*/2, TargetOpcode::G_SUB,
// CHECK-NEXT:          GIM_CheckType, /*MI*/2, /*Op*/1, /*Type*/GILLT_s32,
// CHECK-NEXT:          GIM_CheckType, /*MI*/2, /*Op*/2, /*Type*/GILLT_s32,
// CHECK-NEXT:          GIM_CheckRegBankForClass, /*MI*/2, /*Op*/1, /*RC*/MyTarget::GPR32RegClassID,
// CHECK-NEXT:          GIM_CheckRegBankForClass, /*MI*/2, /*Op*/2, /*RC*/MyTarget::GPR32RegClassID,
// CHECK-NEXT:          GIM_CheckIsSafeToFold, /*InsnID*/1,
// CHECK-NEXT:          GIM_CheckIsSafeToFold, /*InsnID*/2,
// CHECK-NEXT:          // (select:{ *:[i32] } (setcc:{ *:[i32] } GPR32:{ *:[i32] }:$cond, 0:{ *:[i32] }, SETNE:{ *:[Other] }), (sub:{ *:[i32] } GPR32:{ *:[i32] }:$src1, GPR32:{ *:[i32] }:$src2), GPR32:{ *:[i32] }:$src2)  =>  (InstThreeOperands:{ *:[i32] } GPR32:{ *:[i32] }:$cond, GPR32:{ *:[i32] }:$src1, GPR32:{ *:[i32] }:$src2)
// CHECK-NEXT:          GIR_BuildMI, /*InsnID*/0, /*Opcode*/MyTarget::InstThreeOperands,
// CHECK-NEXT:          GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/0, /*OpIdx*/0, // DstI[dst]
// CHECK-NEXT:          GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/1, /*OpIdx*/2, // cond
// CHECK-NEXT:          GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/2, /*OpIdx*/1, // src1
// CHECK-NEXT:          GIR_Copy, /*NewInsnID*/0, /*OldInsnID*/2, /*OpIdx*/2, // src2
// CHECK-NEXT:          GIR_EraseFromParent, /*InsnID*/0,
// CHECK-NEXT:          GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
// CHECK-NEXT:          // GIR_Coverage, 2,
// CHECK-NEXT:          GIR_Done,
// CHECK-NEXT:        // Label 3: @188
// CHECK-NEXT:        GIM_Reject,
// CHECK-NEXT:      // Label 1: @189
// CHECK-NEXT:      GIM_Try, /*On fail goto*//*Label 4*/ 218, // Rule ID 0 //
// CHECK-NEXT:        GIM_CheckType, /*MI*/0, /*Op*/3, /*Type*/GILLT_s32,
// CHECK-NEXT:        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/0, /*RC*/MyTarget::GPR32RegClassID,
// CHECK-NEXT:        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/1, /*RC*/MyTarget::GPR32RegClassID,
// CHECK-NEXT:        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/2, /*RC*/MyTarget::GPR32RegClassID,
// CHECK-NEXT:        GIM_CheckRegBankForClass, /*MI*/0, /*Op*/3, /*RC*/MyTarget::GPR32RegClassID,
// CHECK-NEXT:        // (select:{ *:[i32] } GPR32:{ *:[i32] }:$cond, GPR32:{ *:[i32] }:$src1, GPR32:{ *:[i32] }:$src2)  =>  (InstThreeOperands:{ *:[i32] } GPR32:{ *:[i32] }:$cond, GPR32:{ *:[i32] }:$src1, GPR32:{ *:[i32] }:$src2)
// CHECK-NEXT:        GIR_MutateOpcode, /*InsnID*/0, /*RecycleInsnID*/0, /*Opcode*/MyTarget::InstThreeOperands,
// CHECK-NEXT:        GIR_ConstrainSelectedInstOperands, /*InsnID*/0,
// CHECK-NEXT:        // GIR_Coverage, 0,
// CHECK-NEXT:        GIR_Done,
// CHECK-NEXT:      // Label 4: @218
// CHECK-NEXT:      GIM_Reject,
// CHECK-NEXT:    // Label 0: @219
// CHECK-NEXT:    GIM_Reject,
// CHECK-NEXT:    }
def : Pat<(i32 (select GPR32:$cond, GPR32:$src1, GPR32:$src2)),
          (InstThreeOperands GPR32:$cond, GPR32:$src1, GPR32:$src2)>;

def : Pat<(i32 (select (i32 (setcc GPR32:$cond, (i32 0), (OtherVT SETEQ))),
                       (i32 (sub GPR32:$src1, GPR32:$src2)),
                       GPR32:$src2)),
          (InstThreeOperands GPR32:$cond, GPR32:$src1, GPR32:$src2)>;

def : Pat<(i32 (select (i32 (setcc GPR32:$cond, (i32 0), (OtherVT SETNE))),
                       (i32 (sub GPR32:$src1, GPR32:$src2)),
                       GPR32:$src2)),
          (InstThreeOperands GPR32:$cond, GPR32:$src1, GPR32:$src2)>;
