package kg.manurov.bankmvc.service;

import kg.manurov.bankmvc.dto.cards.CardBlockRequestCreateDto;
import kg.manurov.bankmvc.dto.cards.CardBlockRequestDto;
import kg.manurov.bankmvc.dto.mappers.CardBlockRequestMapper;
import kg.manurov.bankmvc.entities.Card;
import kg.manurov.bankmvc.entities.CardBlockRequest;
import kg.manurov.bankmvc.enums.CardRequestStatus;
import kg.manurov.bankmvc.repositories.CardBlockRequestRepository;
import kg.manurov.bankmvc.repositories.CardRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.NoSuchElementException;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional
public class CardBlockRequestService {

    private final CardBlockRequestRepository cardBlockRequestRepository;
    private final CardBlockRequestMapper mapper;
    private final CardRepository cardRepository;
    private final CardService cardService;

    public CardBlockRequestDto createBlockRequest(CardBlockRequestCreateDto request) {
        log.info("Creating block request for card with ID: {}",
                request.getCardId());

        Card card = cardRepository.findById(request.getCardId())
                .orElseThrow(() -> new NoSuchElementException("User not found"));
        CardBlockRequest blockRequest = mapper.toEntity(card, request);
        CardBlockRequest savedRequest = cardBlockRequestRepository.save(blockRequest);

        log.info("Card block request created with ID: {}", savedRequest.getId());
        return mapper.mapToDto(savedRequest);
    }


    public CardBlockRequestDto approveBlockRequest(Long requestId, String adminComment) {
        log.info("Approving block request with ID: {} by admin",
                requestId);

        CardBlockRequest blockRequest = cardBlockRequestRepository.findById(requestId)
                .orElseThrow(() -> new NoSuchElementException("Block request not found"));

        if (!CardRequestStatus.PENDING.name().equals(blockRequest.getStatus())) {
            throw new IllegalArgumentException("Request already processed");
        }
        cardService.blockCard(blockRequest.getCard().getId(), blockRequest.getReason());


        blockRequest.setStatus(CardRequestStatus.APPROVED.name());
        blockRequest.setAdminComment(adminComment);
        cardBlockRequestRepository.save(blockRequest);

        log.info("Block request approved, card blocked");

        return mapper.mapToDto(blockRequest);
    }


    public void rejectBlockRequest(Long requestId, String adminComment) {
        log.info("Rejecting block request with ID: {} by admin",
                requestId);

        CardBlockRequest blockRequest = cardBlockRequestRepository.findById(requestId)
                .orElseThrow(() -> new NoSuchElementException("Block request not found"));

        if (!CardRequestStatus.PENDING.name().equals(blockRequest.getStatus())) {
            throw new IllegalArgumentException("Request already processed");
        }

        blockRequest.setStatus(CardRequestStatus.REJECTED.name());
        blockRequest.setAdminComment(adminComment);
        cardBlockRequestRepository.save(blockRequest);

        log.info("Block request rejected");
    }


    public void cancelBlockRequest(Long requestId) {
        log.info("Cancelling block request with ID: {} by author", requestId);

        CardBlockRequest blockRequest = cardBlockRequestRepository.findById(requestId)
                .orElseThrow(() -> new NoSuchElementException("Block request not found"));

        if (!CardRequestStatus.PENDING.name().equals(blockRequest.getStatus())) {
            throw new IllegalArgumentException("Can only cancel requests with 'Pending' status");
        }
        blockRequest.setStatus(CardRequestStatus.CANCELLED.name());
        cardBlockRequestRepository.save(blockRequest);
        log.info("Block request cancelled by user");
    }


    @Transactional(readOnly = true)
    public Page<CardBlockRequestDto> getAllBlockRequests(Pageable pageable) {
        return cardBlockRequestRepository.findAll(pageable)
                .map(mapper::mapToDto);
    }

    @Transactional(readOnly = true)
    public Page<CardBlockRequestDto> getUserBlockRequests(Long userId, Pageable pageable) {
        return cardBlockRequestRepository.findByUserId(userId, pageable)
                .map(mapper::mapToDto);
    }

}